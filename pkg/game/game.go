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

func applyGravity(x, y int, pixels PixelArray) {
	if y == Height-1 {
		return
	}

	pixel := pixels.At(x, y)

	if pixels.At(x, y+1).A == 0 {
		pixels.Set(x, y+1, pixel)
		pixels.Set(x, y, Pixel{0, 0, 0, 0})
	} else if x > 0 && pixels.At(x-1, y+1).A == 0 {
		pixels.Set(x-1, y+1, pixel)
		pixels.Set(x, y, Pixel{0, 0, 0, 0})
	} else if x < Width-1 && pixels.At(x+1, y+1).A == 0 {
		pixels.Set(x+1, y+1, pixel)
		pixels.Set(x, y, Pixel{0, 0, 0, 0})
	}
}

func (g *Game) Update() error {
	for y := Height - 1; y >= 0; y-- {
		for x := Width - 1; x >= 0; x-- {
			applyGravity(x, y, g.pixels)
		}
	}

	if ebiten.IsMouseButtonPressed(ebiten.MouseButtonLeft) {
		x, y := ebiten.CursorPosition()
		g.pixels.Set(x, y, Pixel{255, 255, 255, 255})
	}

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
		pixels: make(PixelArray, Width*Height*4),
	}
}
