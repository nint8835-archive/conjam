package game

import (
	"fmt"

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

func (g *Game) Update() error {
	newPixels := make(PixelArray, Width*Height*4)
	copy(newPixels, g.pixels)

	g.pixels = newPixels
	return nil
}

func (g *Game) Draw(screen *ebiten.Image) {
	screen.WritePixels(g.pixels)
	ebitenutil.DebugPrint(screen, fmt.Sprintf("TPS: %0.2f", ebiten.ActualTPS()))
}

func NewGame() *Game {
	return &Game{
		pixels: make(PixelArray, Width*Height*4),
	}
}
