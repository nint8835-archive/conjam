package main

import (
	"fmt"
	"log"

	"github.com/hajimehoshi/ebiten/v2"
	"github.com/hajimehoshi/ebiten/v2/ebitenutil"
)

const width = 640
const height = 480

type Game struct {
	pixels []byte
}

func (g *Game) Update() error {
	if ebiten.IsMouseButtonPressed(ebiten.MouseButtonLeft) {
		x, y := ebiten.CursorPosition()
		baseIndex := (y*width + x) * 4
		g.pixels[baseIndex] = 0xff
		g.pixels[baseIndex+1] = 0xff
		g.pixels[baseIndex+2] = 0xff
		g.pixels[baseIndex+3] = 0xff
	}

	for i := width*height*4 - 4; i >= 0; i -= 4 {
		x := i / 4 % width
		y := i / 4 / width

		if y == height-1 {
			continue
		}

		pixel_r := g.pixels[i]
		pixel_g := g.pixels[i+1]
		pixel_b := g.pixels[i+2]
		pixel_a := g.pixels[i+3]

		if pixel_a == 0 {
			continue
		}

		below_pixel_a := g.pixels[i+(width*4)+3]

		if below_pixel_a == 0 {
			g.pixels[i+width*4] = pixel_r
			g.pixels[i+width*4+1] = pixel_g
			g.pixels[i+width*4+2] = pixel_b
			g.pixels[i+width*4+3] = pixel_a

			g.pixels[i] = 0
			g.pixels[i+1] = 0
			g.pixels[i+2] = 0
			g.pixels[i+3] = 0

			continue
		}

		if x > 0 && g.pixels[i+(width*4)-4+3] == 0 {
			g.pixels[i+(width*4)-4] = pixel_r
			g.pixels[i+(width*4)-4+1] = pixel_g
			g.pixels[i+(width*4)-4+2] = pixel_b
			g.pixels[i+(width*4)-4+3] = pixel_a

			g.pixels[i] = 0
			g.pixels[i+1] = 0
			g.pixels[i+2] = 0
			g.pixels[i+3] = 0

			continue
		}

		if x < width-1 && g.pixels[i+(width*4)+4+3] == 0 {
			g.pixels[i+(width*4)+4] = pixel_r
			g.pixels[i+(width*4)+4+1] = pixel_g
			g.pixels[i+(width*4)+4+2] = pixel_b
			g.pixels[i+(width*4)+4+3] = pixel_a

			g.pixels[i] = 0
			g.pixels[i+1] = 0
			g.pixels[i+2] = 0
			g.pixels[i+3] = 0

			continue
		}
	}

	return nil
}

func (g *Game) Draw(screen *ebiten.Image) {
	screen.WritePixels(g.pixels)
	ebitenutil.DebugPrint(screen, fmt.Sprintf("TPS: %0.2f", ebiten.ActualTPS()))
}

func (g *Game) Layout(outsideWidth, outsideHeight int) (screenWidth, screenHeight int) {
	return 640, 480
}

func main() {
	ebiten.SetWindowSize(640, 480)
	ebiten.SetWindowTitle("Hello, World!")
	if err := ebiten.RunGame(&Game{pixels: make([]byte, width*height*4)}); err != nil {
		log.Fatal(err)
	}
}
