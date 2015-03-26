module Palaio.Player.HumanPlayer;

import Palaio.Player.Player;

import Palaio.GameDisplay;
import Palaio.Board.Board;
import Palaio.Board.Field;
import Palaio.Board.Move;

import Palaio.GameDisplay;
import Palaio.Utilities.Input;

import Derelict.SDL2.sdl;

pragma(lib, "DerelictSDL2.lib");
pragma(lib, "DerelictUtil.lib");

/// Class implementing the human player logic, e.g. handling the input etc.
class HumanPlayer : Player
{
	private:
		Input _input;
		GameDisplay _gd;

	public:
		/// Creates a new object.
		this()
		{
			_gd = GameDisplay.getInstance();
			_input = Input.getInstance();
		}

		/**
		* Gets a move to be made by this player. Handles user input. Overriden from Player class.
		* Returns: Move to be made or null on error.
		*/
		override Move nextMove(Board board)
		{
			SDL_Event e;
			int tempX, tempY;
			Field start = null;
			Field end = null;
			FieldState player = ((board.turn == PlayerPawn.Green) ? FieldState.Green : FieldState.Yellow);
			Move move;

			while(true)
			{
				e = _input.popEvent();

				switch(e.type)
				{
					case SDL_MOUSEBUTTONDOWN:
						if(_gd.getClickedField(e.button.x, e.button.y, tempX, tempY))
						{
							if(start is null) // get the first field
							{
								if(board[tempX, tempY] == FieldState.Block || board[tempX, tempY] == player)
								{
									start = board.getField(tempX, tempY);
									_gd.updateScreen(board, board.getField(tempX, tempY));
								}
							}
							else // get the second field. not so easy this time
							{
								switch(board[tempX, tempY])
								{
									case FieldState.Empty:
										if(start.state == player)
										{
											end = board.getField(tempX, tempY);
											move = new Move(MoveType.Move, start, end);
											if(board.checkMove(move))
												return move;
											else
											{
												start = null;
												end = null;
												_gd.updateScreen(board);
											}
										}
										else
										{
											start = null;
											_gd.updateScreen(board);
										}
										break;

									case FieldState.Block:
										if(start.state == player)
										{
											end = board.getField(tempX, tempY);
											move = new Move(MoveType.Push, start, end);
											if(board.checkMove(move))
												return move;
											else
											{
												start = null;
												end = null;
												_gd.updateScreen(board);
											}
										}
										else
										{
											start = null;
											_gd.updateScreen(board);
										}
										break;

									case player:
										if(start.state == FieldState.Block)
										{
											end = board.getField(tempX, tempY);
											move = new Move(MoveType.Pull, end, start); // start field and end field are reversed in pull (player always on start)
											if(board.checkMove(move))
												return move;
											else
											{
												start = null;
												end = null;
												_gd.updateScreen(board);
											}
										}
										else
										{
											start = null;
											_gd.updateScreen(board);
										}
										break;

									default:
										start = null;
										_gd.updateScreen(board);
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
}
