### IO
The io library provides helpers for io operations.
* **BGI::io::warn _"$message_**: write a given message prefixed with the _Warning:_ prefix to `STDERR`.
```bash
# Example
BGI::io::warn "a message to display"
# this will write to STDERR -> Warning: a message to display
```