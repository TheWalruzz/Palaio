module Palaio.GameDisplay;

import std.math;
import std.conv;
debug import std.stdio;

import Palaio.Config;
import Palaio.Utilities.Screen;
import Palaio.Utilities.Input;
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

/// Singleton class implementing the on-screen display of everything game-related.
class GameDisplay
{
	private:
		static GameDisplay _instance = null;
		Screen _s;
		SDL_Texture* _textures[string];
		BoardArrangement _ba;

		// Dimensions of the pawns.
		int _pawnDimH;
		int _pawnDimW;

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

			_ba = BoardArrangement.Normal;
		}

		~this()
		{
			SDL_DestroyTexture(_textures["board"]);
			SDL_DestroyTexture(_textures["yellow"]);
			SDL_DestroyTexture(_textures["yellow-hl"]);
			SDL_DestroyTexture(_textures["green"]);
			SDL_DestroyTexture(_textures["green-hl"]);
			SDL_DestroyTexture(_textures["block"]);
			SDL_DestroyTexture(_textures["block-hl"]);
		}

	public:
		/**
		* Gets the singleton instance of object.
		* Returns: Reference to the object.
		*/
		static ref GameDisplay getInstance()
		{
			if(_instance is null)
				_instance = new GameDisplay();

			return _instance;
		}

		/**
		* Updates the board on the screen.
		* Params:
		*	board =			Board to be rendered.
		*	highlighted =	Field that should be highlighted, null if none.
		*/
		void updateScreen(Board board, Field highlighted = null)
		{
			// screen coordinates of first field in the row
			int startx;
			int starty;
			int textHeight;

			_s.clear();

			_s.addTexture(_textures["board"], 0, 0, WIDTH, HEIGHT);

			for(int i = 0; i < 7; i++)
			{
				starty = cast(int) ((HEIGHT / 2) - (3.5 * _pawnDimH) + (i * _pawnDimH));
				// startx is calculated using a simple mathematical formula
				startx = cast(int) ((WIDTH / 2) - ((-abs(0.5*(i - 3)) + 4) * _pawnDimW));

				for(int j = 0; j < Board.rowLength[i]; j++)
				{
					if(board[j, i] != FieldState.Empty)
					{
						string state;

						// check if field is highlighted...
						if(highlighted !is null && board.getField(j, i) == highlighted)
							switch(board[j, i])
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
							switch(board[j, i])
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

						if(_ba == BoardArrangement.Normal)
							_s.addTexture(_textures[state], startx + (j * _pawnDimW), starty, _pawnDimW, _pawnDimH);
						else
							_s.addTexture(_textures[state], (_pawnDimW * Board.rowLength[i]) + startx - ((j+1) * _pawnDimW), cast(int) (_pawnDimH * 6.9) - starty, _pawnDimW, _pawnDimH); // cast(int) (_pawnDimH * 6.9) is a quick fix for now
					}
				}
			}

			SDL_Texture* temp = null;
			SDL_Color color = {255, 255, 255};

			temp = _s.getTextTexture(((board.turn == FieldState.Green) ? "Green" : "Yellow"), FONT, color, 22);
			SDL_QueryTexture(temp, null, null, null, &textHeight);
			_s.addTexture(temp, 25, cast(int) ((HEIGHT / 2) - (cast(int) (textHeight/2)) - 1));
			SDL_DestroyTexture(temp);

			temp = _s.getTextTexture(to!string(board.getPoints((_ba == BoardArrangement.Normal) ? FieldState.Yellow : FieldState.Green))~"\0", FONT, color, 32);
			_s.addTexture(temp, 25, cast(int) ((HEIGHT / 2) - 3.5*_pawnDimH));
			SDL_DestroyTexture(temp);

			temp = _s.getTextTexture(to!string(board.getPoints((_ba == BoardArrangement.Normal) ? FieldState.Green : FieldState.Yellow))~"\0", FONT, color, 32);
			_s.addTexture(temp, 25, cast(int) ((HEIGHT / 2) + 3*_pawnDimH));
			SDL_DestroyTexture(temp);

			_s.renderAll();
		}

		/**
		* Gets the field that was clicked.
		* Params:
		*	x =				X coordinate of a click.
		*	y =				Y coordinate of a click.
		*	bx =			X coordinate of the field to be returned as a parameter.
		*	by =			Y coordinate to be returned as a parameter.
		* Returns: true if clicked inside the board boundaries, false otherwise.
		*/
		bool getClickedField(int x, int y, out int bx, out int by)
		{
			if(y >= cast(int) ((HEIGHT / 2) - (3.5 * _pawnDimH)) && y <= cast(int) ((HEIGHT / 2) + (3.5 * _pawnDimH)))
			{
				int i = cast(int) floor((y - ( (HEIGHT / 2) - (3.5 * _pawnDimH))) / _pawnDimH);

				if(x >= cast(int) ((WIDTH / 2) - ((-abs(0.5*(i - 3)) + 4) * _pawnDimW)) && x <= cast(int) ((WIDTH / 2) - ((-abs(0.5*(i - 3)) + 4) * _pawnDimW) + (Board.rowLength[i]+1) * _pawnDimW))
				{
					if(_ba == BoardArrangement.Normal)
					{
						by = i;
						bx = cast(int) (floor((x - ((WIDTH / 2) - ((-abs(0.5*(i - 3)) + 4) * _pawnDimW))) / _pawnDimW));
					}
					else
					{
						by = 6 - i;
						bx = Board.rowLength[i] - 1 - cast(int) floor((x - ((WIDTH / 2) - ((-abs(0.5*(i - 3)) + 4) * _pawnDimW))) / _pawnDimW);
					}

					return true;
				}
			}

			return false;
		}

		/**
		* Puts victory message to the screen.
		* Params:
		*	winner =		Winner of the game.
		*/
		void addVictoryMessage(VictoryState victoryState)
		{
			string text = ((victoryState == VictoryState.Draw) ? "Draw!" : (((victoryState == VictoryState.Green) ? "Green" : "Yellow") ~ " wins!\0"));
			/*int textWidth;

			debug writeln(text);

			SDL_Color color = {255, 255, 255};

			SDL_Texture* temp = _s.getTextTexture(text, FONT, color, 26);
			SDL_QueryTexture(temp, null, null, &textWidth, null);
			_s.addTexture(temp, cast(int) ((WIDTH / 2) - (cast(int) (textWidth/2)) - 1), 10);
			SDL_DestroyTexture(temp);*/

			_s.messageBox("End of game!", text);
		}

		@property
		{
			/// Gets the displayed arrangement of board.
			BoardArrangement boardArrangement() { return _ba; }

			/// Sets the displayed arrangement of board.
			void boardArrangement(BoardArrangement ba) { _ba = ba; }
		}
}
