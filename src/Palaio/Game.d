module Palaio.Game;

import Palaio.Utilities.Input;
import Palaio.GameDisplay;
import Palaio.Board.Board;
import Palaio.Board.Field;
import Palaio.Board.Move;
import Palaio.AppState;
import Palaio.Player.Player;
import Palaio.Player.HumanPlayer;

import Derelict.SDL2.sdl;

pragma(lib, "DerelictSDL2.lib");
pragma(lib, "DerelictUtil.lib");

/// Class representing the general game logic.
class Game : AppState
{
	private:
		GameDisplay _gd;
		Board _board;
		Player _green;
		Player _yellow;

	public:
		/// Creates a new object.
		this()
		{
			_gd = GameDisplay.getInstance();
			_board = new Board();
		}

		/**
		* Clears the board, sets pawns in their appropriate starting positions, clears the score and assigns players' logic.
		* Params:
		* green =			Player logic for green player.
		* yellow =			Player logic for yellow player.
		*/
		void newGame(Player green, Player yellow)
		{
			_board.clear(); // again, just in case

			// set all the pawns to proper positions.
			_board[0, 0] = FieldState.Yellow;
			_board[1, 0] = FieldState.Yellow;
			_board[2, 0] = FieldState.Yellow;
			_board[3, 0] = FieldState.Yellow;
			_board[4, 0] = FieldState.Yellow;

			_board[2, 3] = FieldState.Block;
			_board[3, 3] = FieldState.Block;
			_board[4, 3] = FieldState.Block;
			_board[5, 3] = FieldState.Block;

			_board[0, 6] = FieldState.Green;
			_board[1, 6] = FieldState.Green;
			_board[2, 6] = FieldState.Green;
			_board[3, 6] = FieldState.Green;
			_board[4, 6] = FieldState.Green;

			// set points to 0
			_board.setPoints(FieldState.Green, 0);
			_board.setPoints(FieldState.Yellow, 0);

			_board.player = FieldState.Green;

			_green = green;
			_yellow = yellow;
		}

		/**
		* Checks if game has ended and handles it with a message.
		* Returns: true if game has ended, false otherwise.
		*/
		bool checkVictory()
		{
			VictoryState victoryState = _board.getEndState();
			if(victoryState != VictoryState.None)
			{
				_gd.addVictoryMessage(victoryState);
				_gd.updateScreen(_board);

				return true;
			}

			return false;
		}

		/// Overriden run() method from AppState class.
		override void run()
		{
			Move tempMove;

			_gd.updateScreen(_board);

			while(true)
			{
				tempMove = _green.nextMove(_board);
				if(tempMove !is null)
				{
					_board.doMove(tempMove);

					if(checkVictory())
					{
						SDL_Delay(1000);
						return;
					}

					_gd.updateScreen(_board);
				}
				else
					return;

				tempMove = _yellow.nextMove(_board);
				if(tempMove !is null)
				{
					_board.doMove(tempMove);

					if(checkVictory())
					{
						SDL_Delay(1000);
						return;
					}

					_gd.updateScreen(_board);
				}
				else
					return;
			}
		}
}
