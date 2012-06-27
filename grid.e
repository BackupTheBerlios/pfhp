 --PF_HP: brute force protein_folding in the 2D HP Model.
	--Copyright (C) 2009-2011  Gerrit Leder
	--This program is free software; you can redistribute it and/or
	--modify it under the terms of the GNU General Public License
	--as published by the Free Software Foundation; either version 2
	--of the License, or (at your option) any later version.
	--This program is distributed in the hope that it will be useful,
	--but WITHOUT ANY WARRANTY; without even the implied warranty of
	--MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	--GNU General Public License for more details.
	--You should have received a copy of the GNU General Public License
	--along with this program; if not, write to the Free Software
	--Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
	--Gerrit Leder, Washingtonring 132, 71686 Remseck-Pattonville, GERMANY
	--gerrit.leder@googlemail.com
class
	GRID
	--
	-- twodimensional Grid as an array2
	--

create
	make

feature --Queries:

	a: ARRAY2 [BOOLEAN];

	fold: separate STRING

	used: ARRAY2 [BOOLEAN];
			--Constructor:

	losses: INTEGER;

	number: INTEGER;

	zero: BOOLEAN

	make (i: INTEGER)
		do
				--	create zero.make
			losses := 9999
			fold := ""
			zero := False
			create a.make_filled (zero, 2 * i, 2 * i)
				--a.initialize(zero)
			create used.make_filled (zero, 2 * i, 2 * i)
			--used.initialize(zero)
		end -- make

feature {PF_HP}
			--Commands:

	embed (line, col: INTEGER; seq: separate BOOL_STRING; a_fold: separate STRING)
		require
			--  line=0
			--  col =0
			--  not seq.is_equal (Void)
			--  not a_fold.is_equal(Void)
		local
			i, x, y, l: INTEGER;
			b, one: BOOLEAN;
			temp2: STRING
		do
				--	create b.make
				--	create one.make
				--	io.put_string ("%N")
				--	io.put_string (line.to_string)
				--	io.put_string ("%N")
				--	io.put_string (col.to_string)
				--	io.put_string ("%N")
			x := line
			y := col
			one := True
			if seq.item (1) then
				b := True
			else
				b := False
			end
			a.put (b, line, col)
				--	a.fill_tagged_out_memory
				--	io.put_string (a.tagged_out_memory)
				--	print_grid
				--	io.put_string ("%N")
				---	io.put_string (x.to_string)
				--	io.put_string ("%N")
				--	io.put_string (y.to_string)
				--	io.put_string ("%N")
			number := 0
			used.put (one, x, y)
				--oBdA. seq.item(1) at (0,0), not used
			from
				i := 2
			until
				i = a_fold.count + 2 --        i=seq.count+1
				--
				--
				--
				--
				--
				--
				--
				--
				--
				--
				--
				--
				---
				--not evaluated: i=a_fold.count +2
				--
				--
				--
				--
				--
				--
				--
				--
				--
				--
				--
				--
				---
			loop
				if a_fold.item (i - 1).is_equal ('N') then
					if seq.item (i) then
						b := True
					else
						b := False
					end
					x := x - 1
						--	io.put_string (used.item(x, y).to_boolean.to_string)
						--debug
					if not (used.item (x, y)) then
						a.put (b, x, y)
							--  io.put_string (a.item(x,y).to_string)
							--debug
						used.put (one, x, y)
						--	  io.put_string (used.item(x,y).to_string)
						--debug
					else
						used.initialize (one)
					end
				elseif a_fold.item (i - 1).is_equal ('S') then
					if seq.item (i) then
						b := True
					else
						b := False
					end
					x := x + 1
					if not (used.item (x, y)) then
						a.put (b, x, y)
						used.put (one, x, y)
					else
						used.initialize (one)
					end
				elseif a_fold.item (i - 1).is_equal ('E') then
					if seq.item (i) then
						b := True
					else
						b := False
					end
					y := y + 1
					if not (used.item (x, y)) then
						a.put (b, x, y)
						used.put (one, x, y)
					else
						used.initialize (one)
					end
				elseif a_fold.item (i - 1).is_equal ('W') then
					if seq.item (i) then
						b := True
					else
						b := False
					end
					y := y - 1
					if not (used.item (x, y)) then
						a.put (b, x, y)
						used.put (one, x, y)
					else
						used.initialize (one)
					end
				end
				i := i + 1
					-- print_grid
					--a.do_all (agent print_bool(?))
					--debug
					--
					--
					--
					--
					--
					--
					--
					--
					--a_fold debug:
				temp2 := ""
				from
					l := 1
				until
					l = enclosing_item_fold (a_fold)
				loop
					temp2.append_character (enclosing_item_fold2 (a_fold, l))
						--DEBUG:
					debug
						io.put_integer (l)
						io.put_character (a_fold.item (l))
						io.put_string ("%N")
					end
						--
						--
						--
						--
					l := l + 1
				end
				debug
					io.put_string ("%N%Ntemp2: ")
					io.put_string (temp2)
					io.put_string ("%N")
				end
					--
					--
					--
					--
					--
					--
					--
					--
					--
					--
					--
					--
					--
					--
					--
				fold := temp2
				--	io.put_string (y.to_string)
				--	io.put_string ("%N")
			end
		end -- embed

	calc_losses (line, col: INTEGER; a_fold: separate STRING)
		local
			l, i, x, y: INTEGER;
			temp2: STRING
		do
			x := line
			y := col
			if used.has (zero) then
					--valid fold
				losses := 0
				if a.item (line, col) and then used.item (line, col) then
					if a_fold.item (1).is_equal ('N') then
						losses := losses + (not a.item (line, col - 1)).to_integer + (not a.item (line + 1, col)).to_integer + (not a.item (line, col + 1)).to_integer
						x := x - 1
					elseif a_fold.item (1).is_equal ('S') then
						losses := losses + (not a.item (line, col - 1)).to_integer + (not a.item (line - 1, col)).to_integer + (not a.item (line, col + 1)).to_integer
						x := x + 1
					elseif a_fold.item (1).is_equal ('W') then
						losses := losses + (not a.item (line - 1, col)).to_integer + (not a.item (line, col + 1)).to_integer + (not a.item (line + 1, col)).to_integer
						y := y - 1
					elseif a_fold.item (1).is_equal ('E') then
						losses := losses + (not a.item (line, col - 1)).to_integer + (not a.item (line - 1, col)).to_integer + (not a.item (line + 1, col)).to_integer
						y := y + 1
					end
				elseif not a.item (line, col) then
					if a_fold.item (1).is_equal ('N') then
						x := x - 1
					elseif a_fold.item (1).is_equal ('S') then
						x := x + 1
					elseif a_fold.item (1).is_equal ('W') then
						y := y - 1
					elseif a_fold.item (1).is_equal ('E') then
						y := y + 1
					end
				end
				from
					i := 2
				until
					i = a_fold.count + 1 --        i=seq.count
					--
					--
					--
					--
					--
					--
					--
					--
					--
					--
					--
					--
					---
					--later evaluated: a_fold.item(a_fold.count + 1)
					--
					--
					--
					--
					--
					--
					--
					--
					--
					--
					--
					--
					---
				loop
					if a.item (x, y) and then used.item (x, y) then
						if a_fold.item (i - 1).is_equal ('N') and then a_fold.item (i).is_equal ('N') then
							losses := losses + (not a.item (x, y - 1)).to_integer + (not a.item (x, y + 1)).to_integer
							x := x - 1
						elseif a_fold.item (i - 1).is_equal ('N') and then a_fold.item (i).is_equal ('W') then
							losses := losses + (not a.item (x - 1, y)).to_integer + (not a.item (x, y + 1)).to_integer
							y := y - 1
						elseif a_fold.item (i - 1).is_equal ('W') and then a_fold.item (i).is_equal ('W') then
							losses := losses + (not a.item (x - 1, y)).to_integer + (not a.item (x + 1, y)).to_integer
							y := y - 1
						elseif a_fold.item (i - 1).is_equal ('E') and then a_fold.item (i).is_equal ('N') then
							losses := losses + (not a.item (x, y + 1)).to_integer + (not a.item (x + 1, y)).to_integer
							x := x - 1
						elseif a_fold.item (i - 1).is_equal ('N') and then a_fold.item (i).is_equal ('E') then
							losses := losses + (not a.item (x - 1, y)).to_integer + (not a.item (x, y - 1)).to_integer
							y := y + 1
						elseif a_fold.item (i - 1).is_equal ('W') and then a_fold.item (i).is_equal ('N') then
							losses := losses + (not a.item (x, y - 1)).to_integer + (not a.item (x + 1, y)).to_integer
							x := x - 1
						elseif a_fold.item (i).is_equal ('S') and then a_fold.item (i - 1).is_equal ('S') then
							losses := losses + (not a.item (x, y - 1)).to_integer + (not a.item (x, y + 1)).to_integer
							x := x + 1
						elseif a_fold.item (i).is_equal ('S') and then a_fold.item (i - 1).is_equal ('E') then
							losses := losses + (not a.item (x - 1, y)).to_integer + (not a.item (x, y + 1)).to_integer
							x := x + 1
						elseif a_fold.item (i).is_equal ('E') and then a_fold.item (i - 1).is_equal ('E') then
							losses := losses + (not a.item (x - 1, y)).to_integer + (not a.item (x + 1, y)).to_integer
							y := y + 1
						elseif a_fold.item (i).is_equal ('W') and then a_fold.item (i - 1).is_equal ('S') then
							losses := losses + (not a.item (x, y + 1)).to_integer + (not a.item (x + 1, y)).to_integer
							y := y - 1
						elseif a_fold.item (i).is_equal ('S') and then a_fold.item (i - 1).is_equal ('W') then
							losses := losses + (not a.item (x - 1, y)).to_integer + (not a.item (x, y - 1)).to_integer
							x := x + 1
						elseif a_fold.item (i).is_equal ('E') and then a_fold.item (i - 1).is_equal ('S') then
							losses := losses + (not a.item (x, y - 1)).to_integer + (not a.item (x + 1, y)).to_integer
							y := y + 1
						end
					elseif not a.item (x, y) then
						if a_fold.item (i).is_equal ('N') then
							x := x - 1
						elseif a_fold.item (i).is_equal ('S') then
							x := x + 1
						elseif a_fold.item (i).is_equal ('E') then
							y := y + 1
						elseif a_fold.item (i).is_equal ('W') then
							y := y - 1
						end
					end
					i := i + 1
				end
					--
					--
					--
					--
					--
					--
					--
					--
					--
					--
					--
					--
					--
					--		io.put_string("%N");
					--		io.put_integer(i);
					--		io.put_string("%N");
					--		io.put_string("Should be: ");
					--		io.put_integer(11);
					--		io.put_string("%N");
				i := a_fold.count + 1
				if a.item (x, y) and then used.item (x, y) then
					if a_fold.item (i - 1).is_equal ('N') then
						losses := losses + (not a.item (x, y - 1)).to_integer + (not a.item (x - 1, y)).to_integer + (not a.item (x, y + 1)).to_integer
					elseif a_fold.item (i - 1).is_equal ('S') then
						losses := losses + (not a.item (x, y - 1)).to_integer + (not a.item (x + 1, y)).to_integer + (not a.item (x, y + 1)).to_integer
					elseif a_fold.item (i - 1).is_equal ('E') then
						losses := losses + (not a.item (x - 1, y)).to_integer + (not a.item (x, y + 1)).to_integer + (not a.item (x + 1, y)).to_integer
					elseif a_fold.item (i - 1).is_equal ('W') then
						losses := losses + (not a.item (x, y - 1)).to_integer + (not a.item (x - 1, y)).to_integer + (not a.item (x + 1, y)).to_integer
					end
				end
					--
					--
					--
					--
					--
					--
					--
					--
					--a_fold debug:
				temp2 := ""
				from
					l := 1
				until
					l = enclosing_item_fold (a_fold)
				loop
					temp2.append_character (enclosing_item_fold2 (a_fold, l))
						--DEBUG:
					debug
						io.put_integer (l)
						io.put_character (a_fold.item (l))
						io.put_string ("%N")
					end
						--
						--
						--
						--
					l := l + 1
				end
				debug
					io.put_string ("%N%Ntemp2: ")
					io.put_string (temp2)
					io.put_string ("%N")
				end
					--
					--
					--
					--
					--
					--
					--
					--
					--
					--
					--
					--
					--
					--
					--
				fold := temp2
			else
					--used.has(zero)=false
					--invalid fold
				fold := "XXX" --debug
				losses := 9999
			end
			--Result := losses
			--
			--
			--
			--
			--
			--
			--
			--
			--
			--
			--
			---
			--
			--
			--
			--
			--
			--
			--
			--
			--
			--
			--
			--io.put_integer(losses);
			--
			--
			--
			--
			--
			--
			--
			--
			--
			--
			--
			--debug
		end -- calc_losses
			--   print_grid is
			--     do
			--	 io.put_string("%N")
			--	 a.fill_tagged_out_memory
			--
			--	 io.put_string(a.tagged_out_memory)
			--	 io.put_string("%N")
			--     end
			-- print_grid
			--   print_used is
			--      do
			--	 io.put_string("%N")
			--	 used.fill_tagged_out_memory
			--	 io.put_string(used.tagged_out_memory)
			--	 io.put_string("%N")
			--     end
			-- print_used

	enclosing_item_fold (a_f: separate STRING): INTEGER
		do
			Result := a_f.count + 1
		end

	enclosing_item_fold2 (a_f: separate STRING; an_i: INTEGER): CHARACTER
		do
			debug
				io.put_string ("%Nchar: ")
				io.put_character (a_f.item (an_i))
				io.put_string (" an_i: ")
				io.put_integer (an_i)
				io.put_string ("%N")
			end
			Result := a_f.item (an_i)
		end

	print_bool (bool: separate BOOLEAN)
			-- put_boolean with separator in grid of 8x8
		do
			io.put_boolean (bool)
			io.put_character ('%T')
			if number \\ 8 = 7 then
				io.put_character ('%N')
			end
			number := number + 1
		end

feature {NONE}

end -- class GRID
