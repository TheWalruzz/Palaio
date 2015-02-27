module Palaio.GameTwoPlayers;

import Palaio.GameDisplay;
import Palaio.Board.Board;
import Palaio.Board.Move;
import Palaio.Game;

/// Class representing two player game.
class GameTwoPlayers : Game
{
	private:
		

	public:
		// not really needed - constructor is inherited
		/*this(BoardArrangement ba = BoardArrangement.Normal)
		{
			super(ba);
		}*/

		/// Overriden run() method from Game class.
		override void run()
		{
			Move tempMove;

			_gd.updateScreen(_board, _ba);

			while(true)
			{
				tempMove = handleClick();
				if(tempMove !is null)
				{
					_board.doMove(tempMove);
					_gd.updateScreen(_board, _ba);
				}
				else
					return;

				tempMove = handleClick();
				if(tempMove !is null)
				{
					_board.doMove(tempMove);
					_gd.updateScreen(_board, _ba);
				}
				else
					return;
			}
		}
}
