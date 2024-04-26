package main

import (
	"log"

	"github.com/hajimehoshi/ebiten/v2"

	"github.com/nint8835/conjam/pkg/game"
)

func main() {
	ebiten.SetWindowSize(game.Width, game.Height)
	ebiten.SetWindowTitle("Conjam")
	if err := ebiten.RunGame(game.NewGame()); err != nil {
		log.Fatal(err)
	}
}
