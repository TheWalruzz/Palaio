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
		/// Creates new object.
		this(BoardArrangement ba = BoardArrangement.Normal)
		{
			super(ba);
		}

		/// Overriden run() method from AppState class.
		override void run()
		{
			Move tempMove;

			_gd.updateScreen(_board, _ba);

			while(true)
			{
				if(!movePlayer())
					return;

				// since we have two human players, following lines are not really needed
				/*if(!movePlayer())
					return;*/
			}
		}
}
