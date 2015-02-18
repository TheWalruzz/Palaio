module Palaio.GameDisplay;

import Palaio.Config;
import Palaio.Utilities.Screen;
import Palaio.Board.Board;
import Palaio.Board.Field;

import Derelict.SDL2.sdl;

pragma(lib, "DerelictSDL2.lib");
pragma(lib, "DerelictUtil.lib");

/// Class implementing display of everything game-related.
class GameDisplay
{
	private:
		Screen _s;
		SDL_Texture* _textures[string];

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
		}

		/**
		* Updates the board on the screen.
		* Params:
		*	board =			Board to be rendered.
		*/
		void updateBoard(Board board)
		{
			_s.clear();

			_s.addTexture(_textures["board"], 0, 0, WIDTH, HEIGHT);

			int startx;
			int starty;

			for(int i = 0; i < 7; i++)
			{
				for(int j = 0; j < board.getRowLength(i); j++)
				{
					if(board.getFieldState(j, i) != FieldState.Empty)
					{
						starty = (HEIGHT / 2) - (3*PAWNDIM) + (i * PAWNDIM);
						switch(i)
						{
							case 0:
								startx = ((WIDTH / 2) - (2*PAWNDIM));
							break;

							case 1:
								startx = cast(int) ((WIDTH / 2) - (2.5*PAWNDIM));
							break;

							case 2:
								startx=((WIDTH / 2) - (3 * PAWNDIM));
							break;

							case 3:
								startx=cast(int) ((WIDTH / 2) - (3.5*PAWNDIM));
							break;

							case 4:
								startx=((WIDTH / 2) - (3*PAWNDIM));
							break;

							case 5:
								startx=cast(int)((WIDTH / 2) - (2.5*PAWNDIM));
							break;

							case 6:
								startx=((WIDTH / 2) - (2 * PAWNDIM));
							break;

							default:
							break;
						}

						// !TODO!
						// add proper texture to proper position
						// make some scalability?
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
