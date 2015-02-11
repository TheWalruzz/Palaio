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
		Field _blockStart;
		Field _blockEnd;
		MoveType _moveType;

	public:
		/**
		* Creates a new move.
		* Params:
		*	moveType =		Type of move.
		*	start =			Starting field for player's pawn.
		*	end =			Ending field for player's pawn.
		*	blockStart =	[OPTIONAL] Starting field for block if block is moved.
		*	blockStart =	[OPTIONAL] Ending field for block if block is moved.
		*/
		this(MoveType moveType, Field start, Field end, Field blockStart = null, Field blockEnd = null)
		{
			_moveType = moveType;
			_start = start;
			_end = end;
			_blockStart = blockStart;
			_blockEnd = blockEnd;
		}

		@property
		{
			/// Gets moveType.
			MoveType moveType() { return _moveType; }

			/// Gets starting field of a pawn.
			ref Field startField() { return _start; }

			/// Gets ending field for a pawn.
			ref Field endField() { return _end; }

			/// Gets starting field for a block. Null if move doesn't involve blocks.
			ref Field blockStartField() { return _blockStart; }

			/// Gets ending field for a block. Null if move doesn't involve blocks.
			ref Field blockEndField() { return _blockEnd; }
		}
}
