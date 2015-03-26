module Palaio.Board.Move;

import Palaio.Board.Field;

/// Enum type for move type.
/// Allowed values: MoveType.Move, MoveType.Push, MoveType.Pull.
enum MoveType
{
	Move,
	Push,
	Pull
}

/// Class representing the move.
class Move
{
	private:
		Field _start;
		Field _end;
		MoveType _moveType;
		int _rate; // just for eventual AI stuff

	public:
		/**
		* Creates a new move.
		* Params:
		*	moveType =		Type of move.
		*	start =			Starting field for player's pawn.
		*	end =			Ending field for player's pawn.
		*/
		this(MoveType moveType, Field start, Field end)
		{
			_moveType = moveType;
			_start = start;
			_end = end;
			_rate = 0;
		}

		@property
		{
			/// Gets moveType.
			MoveType moveType() { return _moveType; }

			/// Sets moveType.
			void moveType(MoveType type) { _moveType = type; }

			/// Gets starting field of a pawn.
			ref Field startField() { return _start; }

			/// Gets ending field for a pawn.
			ref Field endField() { return _end; }

			/// Gets the rate value of a move.
			int rate() { return _rate; }

			/**
			* Sets the rate value for a move.
			* Params:
			*	newRate =	New rate value of a move.
			*/
			void rate(int newRate) { _rate = newRate; }
		}
}
