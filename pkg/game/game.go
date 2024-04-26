package game

import (
	"fmt"
	"math/rand/v2"

	"github.com/hajimehoshi/ebiten/v2"
	"github.com/hajimehoshi/ebiten/v2/ebitenutil"
)

const Width = 640
const Height = 480

type PixelArray []byte

func (p PixelArray) At(x, y int) Pixel {
	i := (y*Width + x) * 4
	return Pixel{p[i], p[i+1], p[i+2], p[i+3]}
}

func (p PixelArray) Set(x, y int, pixel Pixel) {
	i := (y*Width + x) * 4
	p[i] = pixel.R
	p[i+1] = pixel.G
	p[i+2] = pixel.B
	p[i+3] = pixel.A
}

type Pixel struct {
	R, G, B, A byte
}

type Game struct {
	pixels PixelArray
}

func (g *Game) Layout(_ int, _ int) (int, int) {
	return Width, Height
}

func (g *Game) processPixel(x int, y int) Pixel {
	currentVal := g.pixels.At(x, y)

	aliveNeighbours := 0

	for dy := -1; dy <= 1; dy++ {
		for dx := -1; dx <= 1; dx++ {
			if dx == 0 && dy == 0 {
				continue
			}

			xx := x + dx
			yy := y + dy

			if xx < 0 || xx >= Width || yy < 0 || yy >= Height {
				continue
			}

			if g.pixels.At(xx, yy).A == 255 {
				aliveNeighbours++
			}
		}
	}

	if currentVal.A == 255 {
		if aliveNeighbours < 2 || aliveNeighbours > 3 {
			return Pixel{0, 0, 0, 0}
		}
	} else {
		if aliveNeighbours == 3 {
			return Pixel{255, 255, 255, 255}
		}
	}

	return currentVal
}

func (g *Game) Update() error {
	newPixels := make(PixelArray, Width*Height*4)
	copy(newPixels, g.pixels)

	for y := 0; y < Height; y++ {
		for x := 0; x < Width; x++ {
			newPixels.Set(x, y, g.processPixel(x, y))
		}
	}

	if ebiten.IsMouseButtonPressed(ebiten.MouseButtonLeft) {
		x, y := ebiten.CursorPosition()
		newPixels.Set(x, y, Pixel{255, 255, 255, 255})
	}

	g.pixels = newPixels
	return nil
}

func (g *Game) Draw(screen *ebiten.Image) {
	screen.WritePixels(g.pixels)
	ebitenutil.DebugPrint(screen, fmt.Sprintf("TPS: %0.2f", ebiten.ActualTPS()))
}

func randomState() PixelArray {
	pixels := make(PixelArray, Width*Height*4)

	for i := 0; i < Width*Height*4; i += 4 {
		if rand.Float64() < 0.5 {
			pixels[i] = 255
			pixels[i+1] = 255
			pixels[i+2] = 255
			pixels[i+3] = 255
		}
	}

	return pixels
}

func NewGame() *Game {
	return &Game{
		pixels: randomState(),
	}
}
