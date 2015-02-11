module Palaio.Board.Move;

import Palaio.Board.Field;

enum MoveType
{
	Move,
	Push,
	Pull
}

/// Class for storing move information.
class Move
{
	private:
		Field _start;
		Field _end;
		Field _blockStart;
		Field _blockEnd;
		MoveType _moveType;

	public:
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
			MoveType moveType() { return _moveType; }
			ref Field startField() { return _start; }
			ref Field endField() { return _end; }
			ref Field blockStartField() { return _blockStart; }
			ref Field blockEndField() { return _blockEnd; }
		}
}
