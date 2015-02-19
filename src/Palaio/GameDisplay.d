module Palaio.GameDisplay;

import std.math;

import Palaio.Config;
import Palaio.Utilities.Screen;
import Palaio.Board.Board;
import Palaio.Board.Field;

import Derelict.SDL2.sdl;

pragma(lib, "DerelictSDL2.lib");
pragma(lib, "DerelictUtil.lib");

/// Type to tell if board should be rendered normally (i.e. Yellow player on the upper half of the board) or reversed.
/// Allowed values: BoardArrangement.Normal, BoardArrangement.Reversed.
enum BoardArrangement
{
	Normal,
	Reversed
}

/// Class implementing the on-screen display of everything game-related.
class GameDisplay
{
	private:
		Screen _s;
		SDL_Texture* _textures[string];

		// Dimensions of the pawns.
		int _pawnDimH;
		int _pawnDimW;

	public:
		/// Creates a new object.
		this()
		{
			_s = Screen.getInstance();

			// load all the needed textures into a map.
			_textures["board"] = _s.getImageTexture("gfx/board.png");
			_textures["yellow"] = _s.getImageTexture("gfx/yellow.png");
			_textures["yellow-hl"] = _s.getImageTexture("gfx/yellow_hl.png");
			_textures["green"] = _s.getImageTexture("gfx/green.png");
			_textures["green-hl"] = _s.getImageTexture("gfx/green_hl.png");
			_textures["block"] = _s.getImageTexture("gfx/block.png");
			_textures["block-hl"] = _s.getImageTexture("gfx/block_hl.png");

			_pawnDimH = cast(int) ((HEIGHT - 64) / 7);
			_pawnDimW = cast(int) (_pawnDimH * (ceil(sqrt(3.0) / 2)));
		}

		/**
		* Updates the board on the screen.
		* Params:
		*	board =			Board to be rendered.
		*	ba =			Board arrangement.
		*	highlighted =	Field that should be highlighted.
		*/
		void updateScreen(Board board, BoardArrangement ba = BoardArrangement.Normal, Field highlighted = null)
		{
			_s.clear();

			_s.addTexture(_textures["board"], 0, 0, WIDTH, HEIGHT);

			// screen coordinates of first field in the row
			int startx;
			int starty;

			for(int i = 0; i < 7; i++)
			{
				starty = cast(int) ((HEIGHT / 2) - (3.5 * _pawnDimH) + (i * _pawnDimH));
				// startx is calculated using a simple mathematical formula
				startx = cast(int) ((WIDTH / 2) - ((-abs(0.5*(i - 3)) + 4) * _pawnDimW));

				for(int j = 0; j < board.getRowLength(i); j++)
				{
					if(board.getFieldState(j, i) != FieldState.Empty)
					{
						string state;

						// check if field is highlighted...
						if(highlighted !is null && board.getField(j, i) == highlighted)
							switch(board.getFieldState(j, i))
							{
								case FieldState.Green:
									state = "green-hl";
								break;

								case FieldState.Yellow:
									state = "yellow-hl";
								break;

								case FieldState.Block:
									state = "block-hl";
								break;

								default:
								break;
							}
						else
							switch(board.getFieldState(j, i))
							{
								case FieldState.Green:
									state = "green";
								break;

								case FieldState.Yellow:
									state = "yellow";
								break;

								case FieldState.Block:
									state = "block";
								break;

								default:
								break;
							}

						if(ba == BoardArrangement.Normal)
							_s.addTexture(_textures[state], startx + (j * _pawnDimW), starty, _pawnDimW, _pawnDimH);
						else
							_s.addTexture(_textures[state], (_pawnDimW * board.getRowLength(i)) + startx - ((j+1) * _pawnDimW), cast(int) (_pawnDimH * 6.9) - starty, _pawnDimW, _pawnDimH); // cast(int) (_pawnDimH * 6.9) is a quick fix for now
					}
				}
			}

			_s.renderAll();
		}

		/**
		* Gets the field that was clicked.
		* Params:
		*	x =				X coordinate of a click.
		*	y =				Y coordinate of a click.
		* Returns: Clicked field if ok, null if clicked outside of the board.
		*/
		Field getClickedField(int x, int y)
		{
			return null;
		}
}
