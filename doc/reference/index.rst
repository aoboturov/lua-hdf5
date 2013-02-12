C declaration composer
======================

.. module:: gcc.cdecl

.. function:: declare(node[, id])

   :param node: GCC tree node
   :param id: identifier function (optional)
   :returns: string of C code

   Format GCC declaration or type node as a string of C code.

   The `tree node`_ ``node`` may be of the following `tree type`_:
   ``array_type``, ``boolean_type``, ``complex_type``, ``enumeral_type``,
   ``field_decl``, ``function_decl``, ``function_type``, ``integer_type``,
   ``pointer_type``, ``real_type``, ``record_type``, ``type_decl``,
   ``union_type``, ``var_decl``, ``vector_type``, or ``void_type``.

   The identifier function ``id`` receives a tree node of type
   ``enumeral_type``, ``field_decl``, ``function_decl``, ``record_type``,
   ``type_decl``, ``union_type``, or ``var_decl`` as its first argument.
   The function may return a string to override the node's name.
   If the function returns ``nil``, and the node is of tree type ``type_decl``,
   the type is expanded to its canonical form.

.. _tree node: http://colberg.org/gcc-lua/reference/#tree-node
.. _tree type: http://colberg.org/gcc-lua/reference/#tree-codes
