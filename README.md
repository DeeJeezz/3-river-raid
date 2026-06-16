# River raid

![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/deejeezz/3-river-raid/deploy.yaml)
![GitHub Tag](https://img.shields.io/github/v/tag/deejeezz/3-river-raid)

https://20_games_challenge.gitlab.io/games/river_raid/

## Where to play

Itch.io - https://deejeezz.itch.io/river-raid

Github Pages - https://deejeezz.github.io/river-raid/

## Description

River Raid was released for the Atari 2600 in 1982. 
The game featured a jet airplane flying up a river, destroying boats, helicopters, jets, and bridges as it went. 
River Raid used procedural generation to make its levels. 
The game used a fixed seed, meaning that every level was the same for all players. 
The game was designed and programmed by Carol Shaw, the first female game designer at Atari, and one of the first worldwide.
 
## Goal:
* Create and animate a jet fighter. The screen will scroll vertically, and the jet can move side to side. The player can accelerate or brake, which will change the vertical scrolling speed.
* Add a river bank on both sides of the level. The river can vary in size, or even split into two streams. Hitting the river bank will kill the player.
* Divide the game into levels. Between levels, the river will narrow, and there will be a bridge crossing it. Bridges act as checkpoints. The player must shoot the bridge, colliding with it will kill the player.
* Add some enemies! Boats and helicopters will move back and forth across the river. Jets will cross the entire screen. Colliding with an enemy will kill the player.
* Add fuel depots. Flying over these will replenish the player’s fuel reserves. The player can shoot and destroy fuel depots, but colliding with them doesn’t kill the player.
* Add a UI with a life counter, score, and fuel gauge. The fuel gauge will drain slowly, and the player will die if it reaches “empty”
* Give the player the ability to shoot things! Shooting things increases the player score.

## Stretch goals:
* Not sure how to make the game infinitely long? The easy way would be to create multiple hand-crafted levels that start and end with a bridge. The fun way would be to generate the levels dynamically on the fly.
* The Atari 2600 could only display limited sprites. Modern computers are capable of creating massive particle effect explosions. You know what to do 😉
