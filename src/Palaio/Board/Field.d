module Palaio.Board.Field;

import Palaio.Utilities.Vector;

/// Enum type representing state of a field e.g. if it's empty or occupied by a pawn.
/// Allowed values: FieldState.Empty, FieldState.Green, FieldState.Yellow, FieldState.Block.
enum FieldState
{
	Empty,
	Green,
	Yellow,
	Block
}

/// Class representing the field.
class Field
{
	private:
		int _x;
		int _y;
		FieldState _state;
		Vector!Field _neighbours;

	public:
		/**
		* Creates new field.
		* Params:
		*	x =				X index of a field.
		*	y =				Y index of a field.
		*	fieldState =	[OPTIONAL] State of a field.
		*/
		this(int x, int y, FieldState fieldState = FieldState.Empty)
		{
			_x = x;
			_y = y;
			_state = fieldState;

			_neighbours = new Vector!Field();
		}

		/**
		* Adds a reference to neighbouring field.
		* Params:
		*	neighbour =		Field to be added.
		*/
		void addNeighbour(ref Field neighbour)
		{
			_neighbours.pushBack(neighbour);
		}

		/**
		* Searches for specified field in the neighbour container.
		* Params:
		*	neighbour =		Field to search for.
		* Returns: Position on the neighbour container.
		*/
		int searchNeighbour(ref Field neighbour)
		{
			for(int i = 0; i < _neighbours.length; i++)
				if(_neighbours[i].x == neighbour.x && _neighbours[i].y == neighbour.y)
					return i;

			return -1;
		}

		/**
		* Checks if specified field is connected to this field.
		* Params:
		*	neighbour =		Field to check for.
		* Returns: true if field exists in the container, false otherwise.
		*/
		bool checkNeighbour(ref Field neighbour)
		{
			return searchNeighbour(neighbour) > -1;
		}

		alias opEquals = Object.opEquals;

		/**
		* Overloaded == operator for fields. Checks if both fields' coordinates are identical.
		* Returns: true if coordinates of both fields are identical, false otherwise.
		*/
		bool opEquals(ref Field b)
		{
			if(this is b)
				return true;

			if(this is null || b is null)
				return false;

			if(this._x == b.x && this._y == b.y)
				return true;

			return false;
		}

		@property
		{
			/// Sets the state of a field.
			void state(FieldState newState) { _state = newState; }

			/// Gets the state of a field.
			FieldState state() { return _state; }

			/// Gets the neighbouring fields vector.
			Vector!Field neighbours() { return _neighbours; }

			/// Gets x index of a field.
			int x() { return _x; }

			/// Gets y index of a field.
			int y() { return _y; }
		}
}
