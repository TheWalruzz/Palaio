module Palaio.Game;

import Palaio.Utilities.Input;
import Palaio.GameDisplay;
import Palaio.Board.Board;
import Palaio.Board.Field;
import Palaio.Board.Move;
import Palaio.AppState;

import Derelict.SDL2.sdl;

pragma(lib, "DerelictSDL2.lib");
pragma(lib, "DerelictUtil.lib");

/// Class representing the general game logic (to be further extended into child classes).
class Game : AppState
{
	protected:
		GameDisplay _gd;
		Input _input;
		Board _board;
		BoardArrangement _ba;

	public:
		/// Creates a new object.
		this(BoardArrangement ba = BoardArrangement.Normal)
		{
			_gd = new GameDisplay();
			_board = new Board();
			_ba = ba;

			_input = Input.getInstance();
		}

		/// Clears the board, sets pawns in their appropriate starting positions and clears the score.
		void newGame()
		{
			_board.clear(); // again, just in case

			// set all the pawns to proper positions.
			_board.setFieldState(0, 0, FieldState.Yellow);
			_board.setFieldState(1, 0, FieldState.Yellow);
			_board.setFieldState(2, 0, FieldState.Yellow);
			_board.setFieldState(3, 0, FieldState.Yellow);
			_board.setFieldState(4, 0, FieldState.Yellow);

			_board.setFieldState(2, 3, FieldState.Block);
			_board.setFieldState(3, 3, FieldState.Block);
			_board.setFieldState(4, 3, FieldState.Block);
			_board.setFieldState(5, 3, FieldState.Block);

			_board.setFieldState(0, 6, FieldState.Green);
			_board.setFieldState(1, 6, FieldState.Green);
			_board.setFieldState(2, 6, FieldState.Green);
			_board.setFieldState(3, 6, FieldState.Green);
			_board.setFieldState(4, 6, FieldState.Green);

			// set points to 0
			_board.setPoints(Player.Green, 0);
			_board.setPoints(Player.Yellow, 0);

			_board.player = Player.Green;
		}

		/**
		* Gets a move that was clicked by player.
		* Returns: The valid move that was chosen by player, null if invalid.
		*/
		Move handleClick()
		{
			SDL_Event e;
			int tempX, tempY;
			Field start = null;
			Field end = null;
			FieldState player = ((_board.player == Player.Green) ? FieldState.Green : FieldState.Yellow);
			Move move;

			while(true)
			{
				e = _input.popEvent();

				switch(e.type)
				{
					case SDL_MOUSEBUTTONDOWN:
						if(_gd.getClickedField(e.button.x, e.button.y, tempX, tempY, _ba))
						{
							if(start is null) // get the first field
							{
								if(_board.getFieldState(tempX, tempY) == FieldState.Block || _board.getFieldState(tempX, tempY) == player)
								{
									start = _board.getField(tempX, tempY);
									_gd.updateScreen(_board, _ba, _board.getField(tempX, tempY));
								}
							}
							else // get the second field. not so easy this time
							{
								switch(_board.getFieldState(tempX, tempY))
								{
									case FieldState.Empty:
										if(start.state == player)
										{
											end = _board.getField(tempX, tempY);
											move = new Move(MoveType.Move, start, end);
											if(_board.checkMove(move))
												return move;
											else
											{
												start = null;
												end = null;
												_gd.updateScreen(_board, _ba);
											}
										}
										else
										{
											start = null;
											_gd.updateScreen(_board, _ba);
										}
									break;

									case FieldState.Block:
										if(start.state == player)
										{
											end = _board.getField(tempX, tempY);
											move = new Move(MoveType.Push, start, end);
											if(_board.checkMove(move))
												return move;
											else
											{
												start = null;
												end = null;
												_gd.updateScreen(_board, _ba);
											}
										}
										else
										{
											start = null;
											_gd.updateScreen(_board, _ba);
										}
									break;

									case player:
										if(start.state == FieldState.Block)
										{
											end = _board.getField(tempX, tempY);
											move = new Move(MoveType.Pull, end, start); // start field and end field are reversed in pull (player always on start)
											if(_board.checkMove(move))
												return move;
											else
											{
												start = null;
												end = null;
												_gd.updateScreen(_board, _ba);
											}
										}
										else
										{
											start = null;
											_gd.updateScreen(_board, _ba);
										}
									break;

									default:
										start = null;
										_gd.updateScreen(_board, _ba);
									break;
								}
							}	
						}

					break;

					case SDL_QUIT:
						// handle this situation properely
						return null;
					break;

					default: // type could be 0 if queue was empty, so we have default here
					break;
				}
			}

			return null;
		}

		@property 
		{
			/// Sets the board arrangement.
			void boardArrangement(BoardArrangement ba) { _ba = ba; }

			/// Gets the board arrangement.
			BoardArrangement boardArrangement() { return _ba; }
		}
}
