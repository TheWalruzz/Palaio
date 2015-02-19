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
	private:
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
			_input.clearQueue(); // just in case
		}

		/// Sets pawns in their appropriate starting positions.
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
		}

		void handleClick()
		{
		}

		@property 
		{
			/// Sets the board arrangement.
			void boardArrangement(BoardArrangement ba) { _ba = ba; }

			/// Gets the board arrangement.
			BoardArrangement boardArrangement() { return _ba; }
		}
}
