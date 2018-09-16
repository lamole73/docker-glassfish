#!/bin/sh

set -e

# Check initialization is already run
if [ ! -e /docker-entrypoint.d.run ]
then
  # Run initialization .sh files existing on /docker-entrypoint.d folder
  echo "Run initialization .sh files existing on /docker-entrypoint.d folder..."
  for f in /docker-entrypoint.d/*; do
    case "$f" in
      *.sh)
        # If executable run it, else souce it
        if [ -x "$f" ]; then
          echo "$0: running $f"
          "$f"
        else
          echo "$0: sourcing $f"
          . "$f"
        fi
        ;;
      *)
        echo "$0: ignoring $f" ;;
    esac
    echo
  done
  
  # Mark initialization is run
  echo "Mark initialization is run."
  touch /docker-entrypoint.d.run
else
  echo "Skip initialization as already run."
fi

exec "$@"
