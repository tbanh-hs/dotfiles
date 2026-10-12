/**
 * Pi Notify Extension
 *
 * Sends a native notification when Pi agent is done and waiting for input.
 * Supports multiple terminal protocols:
 * - OSC 777: Ghostty, iTerm2, WezTerm, rxvt-unicode
 * - OSC 99: Kitty
 * - Windows toast: Windows Terminal (WSL), with soft IM sound
 * - macOS: Notification Center via osascript, with soft Pop sound
 * - notify-send: Linux desktop fallback (works inside tmux)
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { execFile } from "node:child_process";
import { writeFileSync } from "node:fs";

function windowsToastScript(title: string, body: string): string {
  const type = "Windows.UI.Notifications";
  const mgr = `[${type}.ToastNotificationManager, ${type}, ContentType = WindowsRuntime]`;
  const template = `[${type}.ToastTemplateType]::ToastText01`;
  const toast = `[${type}.ToastNotification]::new($xml)`;
  return [
    `${mgr} > $null`,
    `$xml = [${type}.ToastNotificationManager]::GetTemplateContent(${template})`,
    `$xml.GetElementsByTagName('text')[0].AppendChild($xml.CreateTextNode('${body}')) > $null`,
    `$audio = $xml.CreateElement('audio')`,
    `$audio.SetAttribute('src', 'ms-winsoundevent:Notification.IM')`,
    `$xml.GetElementsByTagName('toast')[0].AppendChild($audio) > $null`,
    `[${type}.ToastNotificationManager]::CreateToastNotifier('${title}').Show(${toast})`,
  ].join("; ");
}

/**
 * Write an escape sequence straight to the controlling terminal,
 * bypassing Pi's fullscreen TUI renderer (which owns stdout).
 * Inside tmux, wrap in DCS passthrough so the outer terminal
 * (Ghostty) actually receives the OSC sequence.
 *
 * Requires `set -g allow-passthrough on` in tmux.conf for the
 * OSC part. The notify-send / bell parts work without it.
 */
function writeToTerminal(seq: string): void {
  let payload = seq;
  if (process.env.TMUX) {
    // DCS passthrough: ESC Ptmux; ESC <seq> ESC \
    // seq already starts with ESC, so this doubles it correctly.
    payload = `\x1bPtmux;\x1b${seq}\x1b\\`;
  }
  try {
    writeFileSync("/dev/tty", payload);
  } catch {
    // Fallback when /dev/tty is unavailable (e.g. headless): stderr
    // bypasses Ink's stdout rendering more reliably than stdout.
    process.stderr.write(payload);
  }
}

function notifyOSC777(title: string, body: string): void {
  writeToTerminal(`\x1b]777;notify;${title};${body}\x07`);
}

function notifyOSC99(title: string, body: string): void {
  // Kitty OSC 99: i=notification id, d=0 means not done yet, p=body for second part
  writeToTerminal(`\x1b]99;i=1:d=0;${title}\x1b\\`);
  writeToTerminal(`\x1b]99;i=1:p=body;${body}\x1b\\`);
}

function notifyBell(): void {
  writeToTerminal(`\x07`);
}

function appleScriptEscape(s: string): string {
  return s.replace(/\\/g, "\\\\").replace(/"/g, '\\"');
}

function notifyMacos(title: string, body: string): void {
  // Native Notification Center popup with a soft system sound.
  // No dependencies — osascript ships with macOS. Silent failure
  // (e.g. notifications denied) still leaves the OSC/bell path.
  const script =
    `display notification "${appleScriptEscape(body)}" ` +
    `with title "${appleScriptEscape(title)}" sound name "Pop"`;
  execFile("osascript", ["-e", script], () => {});
}

function notifyDesktop(title: string, body: string): void {
  // Best-effort Linux desktop notification. Works inside tmux,
  // where OSC sequences get swallowed. Fails silently headless.
  execFile(
    "notify-send",
    ["-h", "string:sound-name:message", title, body],
    (err) => {
      if (err) {
        // notify-send missing or no DBUS session — ignore, OSC/bell still ran.
      }
    },
  );
}

function playSound(): void {
  // Soft incoming-message blip at ~30% volume. Respects mute/routing
  // via PipeWire. Silent failure headless — notification still shows.
  execFile(
    "paplay",
    [
      "--volume=20000",
      "/usr/share/sounds/freedesktop/stereo/message.oga",
    ],
    (err) => {
      if (err) {
        execFile("canberra-gtk-play", ["-i", "message"], () => {});
      }
    },
  );
}

function notifyWindows(title: string, body: string): void {
  execFile("powershell.exe", ["-NoProfile", "-Command", windowsToastScript(title, body)]);
}

function notify(title: string, body: string): void {
  // Native desktop notification first: reliable inside tmux, where
  // raw OSC sequences get swallowed.
  if (process.platform === "darwin") {
    notifyMacos(title, body);
  } else if (process.platform === "linux") {
    notifyDesktop(title, body);
    playSound();
  }
  // Terminal urgency hint always helps (taskbar flash / bell).
  notifyBell();

  if (process.env.WT_SESSION) {
    notifyWindows(title, body);
  } else if (process.env.KITTY_WINDOW_ID) {
    notifyOSC99(title, body);
  } else {
    notifyOSC777(title, body);
  }
}

export default function (pi: ExtensionAPI) {
  // `agent_end` fires after each low-level run; Pi may still retry, compact,
  // or continue with queued follow-ups. Notify only after the full run settles.
  pi.on("agent_settled", async (_event, ctx) => {
    try {
      notify("Pi", "Ready for input");
      // In-TUI toast as well (visible even if native notification is blocked).
      ctx.ui.notify("Pi ready for input", "info");
    } catch (err) {
      console.error("[notify] failed:", err);
    }
  });
}
