module Palaio.Utilities.Node;

import Palaio.Utilities.Vector;

class Node(T)
{
    private:
        T _data;
        Node _parent;
        Vector!Node _children;

    public:
        this()
        {
            _parent=null;
            _children=new Vector!Node();
        }

        this(ref Node parent)
        {
            this();
            _parent=parent;
        }

        this(ref Node parent,ref Field[][] data)
        {
            this(parent);
            _data=data;
        }

        this(Field[][] data)
        {
            this();
            _data=data;
        }


        void addChild(ref Node child)
        {
            child.parent=this;
            _children.pushBack(child);
        }

        void addChild(ref T data)
        {
            Node child=new Node(this,data);
            _children.pushBack(child);
        }

        ref Node getChild(int i)
        {
            return _children[i];
        }

        ref Node opIndex(int i)
        {
            return _children[i];
        }

        void opIndexAssign(ref Node value, int i)
        {
            _children[i]=value;
        }

        void removeChild(int i)
        {
            _children.remove(i);
        }

        void removeChildren()
        {
            _children.clear();
        }

        void sortChildren()
        {
            Node temp=new Node(this);

            // stuff

            destroy(temp);
        }

		void sortChildren()
		{
			_children.sort();
		}

        @property ref Vector!Node children() { return _children; }
        @property ref Node parent() { return _parent; }
        @property ref T data() { return _data; }
        @property int length() { return _children.length; }
        @property bool isLeaf() { return (_children.length==0); }
}
