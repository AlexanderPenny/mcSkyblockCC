# mcSkyblockCC

Lua scripts for a ComputerCraft / CC:Tweaked banking and casino support network in a Minecraft Skyblock world.

The project is built around a central rednet server that stores player account balances, with client computers for ATMs, teller desks, customer displays, door access, and casino-facing screens.

## Features

- Central account server using rednet protocols.
- Debit-card style account lookup from disks containing a `CheckSum.txt` file.
- Simple ATM balance checker plus a larger menu-driven ATM interface.
- Teller desk script for writing account balances from an authorised bank computer.
- Customer leaderboard monitor that polls balances and ranks players.
- Door lock script with employee password access and a redstone output.
- Display and sound scripts for casino or shop atmosphere.
- Placeholder files for future gambling games.

## Requirements

- Minecraft with ComputerCraft or CC:Tweaked.
- Computers or advanced computers for the server and client terminals.
- Wired or wireless modems configured for rednet.
- Disk drives and disks for debit cards.
- Monitors for customer-facing screens.
- Redstone output support for the door lock script.
- A speaker peripheral if using `musicController.lua`.

## Project Layout

| Path | Purpose |
| --- | --- |
| `serverPassiveQuery.lua` | Main rednet account server. Handles reads, writes, updates, transfers, registration, and checksum lookup. |
| `ATM.lua` | Simple ATM flow that reads a disk checksum and prints the account balance. |
| `ATM2.lua` | Menu-based ATM UI with balance checking and early transfer UI work. |
| `tellerDesk.lua` | Teller terminal for setting account balances through the `Write` protocol. |
| `autoTeller.lua` | Animated teller/customer screen. |
| `doorLock.lua` | Password-protected door control using a redstone output. |
| `musicController.lua` | Loops a speaker sound. |
| `CustomerScreens/leaderboard.lua` | Monitor leaderboard for account balances. |
| `CustomerScreens/Pysop.lua` | Casino-style idle display loop. |
| `GambleGames/*.lua` | Empty placeholder scripts for future gambling games. |
| `Info.txt` | Reference list of sample account checksums and network notes. |

## Data Model

The main server expects account data under `/Data` on the server computer.

Each account balance is stored in a file named after the account checksum:

```text
/Data/CHz01G.txt
```

The file content should be the current numeric balance:

```text
100
```

The server also refers to:

- `/Data/registeredComputers.txt` for computer ID to owner checksum mappings.
- `/Data/info.txt` for checksum lookup by name.

Debit card disks should contain:

```text
/disk/CheckSum.txt
```

with the matching checksum as the first line, for example:

```text
CHz01G
```

## Rednet Protocols

`serverPassiveQuery.lua` listens for these protocol names:

| Protocol | Message format | Result |
| --- | --- | --- |
| `Read` | `CHECKSUM` | Returns the account balance from `/Data/CHECKSUM.txt`. |
| `Write` | `CHECKSUM:VALUE` | Sets an account balance. Intended for the authorised bank computer. |
| `Update` | `CHECKSUM:DELTA` | Adds `DELTA` to the current account balance. |
| `Transaction` | `FROMCHECKSUM:TOCHECKSUM:VALUE` | Moves value from one account to another. |
| `Register` | `CHECKSUM` | Registers the sender computer ID to a checksum. |
| `getChecksum` | Account name | Looks up a checksum from `/Data/info.txt`. |

Most client scripts currently send requests to computer ID `5`, which is noted in `Info.txt` as the main server.

## Setup

1. Place `serverPassiveQuery.lua` on the main banking server computer.
2. Ensure the server computer's ID is `5`, or update each client script to use the correct server ID.
3. Attach modems on the sides used by the scripts, or update the hard-coded `rednet.open(...)` sides.
4. Create `/Data` on the server computer.
5. Add one balance file per account, such as `/Data/CHz01G.txt`.
6. Create `/Data/registeredComputers.txt` and `/Data/info.txt` if you want registration and checksum lookup.
7. Place client scripts on the matching in-game computers.
8. Create debit card disks with `/disk/CheckSum.txt` containing a valid checksum.

## Running

Run the server first:

```text
serverPassiveQuery
```

Then run client scripts on their intended computers:

```text
ATM
ATM2
tellerDesk
doorLock
CustomerScreens/leaderboard
CustomerScreens/Pysop
```

ComputerCraft normally lets you run a program by its filename without the `.lua` extension.

## Configuration Notes

Several values are currently hard-coded and should be checked before deployment:

- Server computer ID: `5`.
- ATM modem side: `back`.
- ATM disk drive side: `Bottom` in the current scripts.
- Server modem sides: `top` and `left`.
- Teller desk modem side: `right`.
- Leaderboard modem side: `left`.
- Leaderboard monitor name: `monitor_2`.
- Door lock redstone output side: `left`.
- Door lock employee and admin passwords.
- Account checksums and player names in `Info.txt`, `ATM2.lua`, and `CustomerScreens/leaderboard.lua`.

## Current Status

- `ATM.lua` is a simple balance checker.
- `ATM2.lua` has a clickable menu and balance screen, but withdraw, deposit, and transfer behaviour is not fully implemented.
- `GambleGames/slots.lua`, `GambleGames/roulette.lua`, and `GambleGames/csgoCaseUnboxing.lua` are empty placeholders.
- Passwords and account checksums are stored in plain text, so this should be treated as an in-game project rather than a secure banking system.

## License

This project is licensed under the MIT License. See `LICENSE` for details.
