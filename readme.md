# steamflags

sf is a set of shell scripts for managing all the flags and env vars for launching games.

instead of setting the same flags for every single proton game, and needing to modify them in the steam ui, instead you can set them both globally and per-game in a single file

it also has gamescope integration.


## installation

just clone this repo to wherever you want and then use `launch %command%` as your launch parameters for steam games you want to use it on.

e.g.
```
export SF_INSTALL_DIR=/opt/sf
git clone httpsL//github.com/elee1766/sf.git $INSTALL_DIR
cp $INSTALL_DIR/games.example.conf $INSTALL_DIR/games.conf
```

## games.conf

ini like config config. `[default]` section applies to all games, `[<appid>]` overrides per game. `[scrub]` strips env vars matching regex patterns before launch. Comments with `#`.

```ini
# strip secrets from game processes
[scrub]
KEY$
TOKEN$
SECRET

[default]
# env vars here apply to all games
MANGOHUD=1
__GL_THREADED_OPTIMIZATION=1

# gamemode: off by default, SF_GAMEMODE=1 to enable
SF_GAMEMODE=1

[730] # CS2
SF_GAMESCOPE=1                   # enable gamescope for this game

[2357570] # Overwatch 2
MANGOHUD=0                       # disable mangohud (overrides default)
DXVK_HUD=fps,compiler            # show dxvk hud instead
PROTON_DXVK_LLASYNC=1            # use low-latency async dxvk variant
-__GL_THREADED_OPTIMIZATION      # unset a default with -KEY
```

### features

| Variable | Default | Description |
|----------|---------|-------------|
| `SF_GAMEMODE` | `0` | `1` to wrap with `gamemoderun` |
| `SF_GAMESCOPE` | `0` | `1` to wrap with `gamescope` |
| `SF_GAMESCOPE_W` | `2560` | gamescope output width |
| `SF_GAMESCOPE_H` | `1440` | gamescope output height |
| `SF_GAMESCOPE_R` | `360` | gamescope refresh rate |
| `SF_GAMESCOPE_EXTRA` | `--immediate-flips` | extra gamescope flags |

any other `KEY=value` is exported as an env var. use `-KEY` to unset a default for a specific game.

## CLI

`sf search [query]` -- list installed games, optionally filter by name. use this to find steam app IDs for your config.
