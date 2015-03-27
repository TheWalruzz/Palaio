module Palaio.Player.Player;

import Palaio.GameDisplay;
import Palaio.Board.Board;
import Palaio.Board.Move;

/// Interface for representing player logic.
interface Player
{
	public:
		/**
		* Returns the move to be made by player based off referenced board state.
		* Has to be overriden by derivative classes.
		* Params:
		*	board =		Actual state of the board.
		* Returns: Move to make.
		*/
		Move nextMove(Board board);
}
