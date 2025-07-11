# 🔒 Flutter Doorlock App

Flutter app which links to Firebase to monitor door status and
intruder alert set by Raspberry Pi sensors.
Listens to updates on door status and last intruder timestamp
in Firebase Realtime Database.

---

## Firebase Structure Example

```json
{
	"door_status": "locked",
	"last_intruder_detected": 1720710847.1234 // Unix Epoch
}
```

---

## Overview

-   Displays the current door status in real-time (`locked` or `unlocked`)
-   Shows the timestamp of the most recent intruder detection
-   Animated lock/unlock icons provide smooth visual feedback
-   Built with Flutter and powered by Firebase Realtime Database for instant updates
