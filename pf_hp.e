 --PF_HP: brute force proteinfolding in the 2D HP Model.
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
	PF_HP
	--
	-- The "Proteinfolding in HP-Model" for Eiffel :-)
	--
	-- To compile type command :
	-- C:\Source\PFHP>"\Apps\EiffelStudio 6.8 GPL\studio\spec\win64\bin\ec.exe" -finalize -config pf_hp.ecf
	-- C:\Source\PFHP\EIFGENs\pf_hp\F_code>"\Apps\EiffelStudio 6.8 GPL\studio\spec\win64\bin\finish_freezing.exe"
	--
	-- Run with command : pf_hp.exe
	--

create
	make

feature -- Access

	enclosing_read_loss (a_grid: separate GRID)
			-- read the a_grid.losses into current.loss
		do
			loss := a_grid.losses
		end

feature --Queries:
			--	n : NONE;

	computers: LINKED_LIST [separate GRID]

	number: INTEGER;

	seq: BOOL_STRING;

	strseq: STRING;

	iseq: INTEGER;

	zero, one: BOOLEAN;

	fold: STRING;

	temp: STRING;

	folds: LINKED_LIST [STRING];

	losses, indices: LINKED_LIST [INTEGER];
			--	indices: ARRAY[INTEGER];

	n: INTEGER;

	i: INTEGER;

	loss, min: INTEGER

	make
			--Constructor:
		do
			create computers.make
			min := 9999
				--loss:=0
				--	io.put_string(io.last_string.is_bit.to_string);
				--	io.put_string("%N")	
			from
				io.put_string ("Abbruch jederzeit mit STRG-C! Stop execution with CTRL-C!%N")
				io.put_string ("                           123456789012345%N")
				io.put_string ("Bitte Bitsequenz eingeben: ")
				io.read_line
			until
				(not io.last_string.is_empty) --and then io.last_string.is_bit
			loop
				io.put_string ("%N")
				io.put_string ("Keine Bitsequenz eingegeben. Besteht nur aus 0 und 1 in beliebiger Reihenfolge!%N")
				io.put_string ("Abbruch jederzeit mit STRG-C (CTRL-C)!%N")
				io.put_string ("                           123456789012345%N")
				io.put_string ("Bitte Bitsequenz eingeben: ")
				io.read_line
			end
				-- iseq:=io.last_integer
			strseq := io.last_string
			create folds.make
			create losses.make
			create indices.make --from_collection(losses)
			create fold.make (strseq.count - 1)
			create seq.make (strseq.count)
				--create zero.make
			zero := False
			one := True
				--	 create grid.make(seq.count)
			from
				i := 1
			until
				i = strseq.count
			loop
				debug
					io.put_string (i.out)
				end
				io.put_string ("%N")
				fold.append_character ('N')
				i := i + 1
			end
			from
				i := 1
			until
				i = strseq.count + 1
			loop
				debug
					io.put_string (i.out)
				end
				io.put_string ("%N")
				if strseq.item (i).is_equal ('1') then
					seq.put (True, i)
				else
					seq.put (False, i)
				end
				i := i + 1
			end
			io.put_string (seq.out)
			io.put_string ("%N123456789012345")
			io.put_string ("%Nhp-sequence")
			io.put_string ("%N")
			io.put_string ("%N")
				--	 io.put_integer(fold.count);
				--	 gen_folds (10);
			io.put_string (fold.string)
			io.put_string ("%N12345678901234")
			io.put_string ("%Nfirst fold")
			io.put_string ("%N%N%N")
			gen_folds (fold, seq, i)
				--	 grid.embedd(0, 0, seq, fold)
				-- grid.print_grid
				--	 if (grid.used.has(zero)) then io.put_integer(grid.calc_losses(0, 0, fold)) end
			io.put_string ("%N")
				--	print_losses;
				--	print_folds;
				--	print_indices;
				--
				--
				--
				--
				--
				--
				--
				--
				--
				--output:
			number := 0
			io.put_string ("%N%N")
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
			temp := ""
			debug
				print_computers
			end
			io.put_string ("%NOptimal fold(s):")
			io.put_string ("%N")
			number := 1
			print_min_fold
			io.put_string ("%NMinimal losses: ")
			io.put_integer (min)
			io.put_character ('%N')
			io.put_character ('%N')
				--	print_indices;
				--	grid.print_used;
				--
				--	from i:=0
				--	until i=100
				--	loop io.put_string(folds.item(i));
				--	io.put_string("%N");
				--	i:=i+1
				--	end
				--
			io.put_string (seq.out)
			io.put_string ("%N123456789012345")
			io.put_string ("%Nhp-sequence")
				--       create a.make (-11,11,-11,11);
				--                print_array(a);
				--                    a.fill_tagged_out_memory;
				--                a.item(line, col);
				--	 grid.a.set_area(n,-11,11,-11,11);
				--grid.print_grid;
			io.put_string ("%N")
			io.put_string ("%NBeenden mit Eingabetaste!")
			io.read_line
		end -- make

	enclosing_computers_item (a_g: separate GRID): INTEGER
		do
			Result := enclosing_computers_item_fold (a_g.fold)
		end

	enclosing_computers_item_fold (a_f: separate STRING): INTEGER
		do
			Result := a_f.count + 1
		end

	enclosing_computers_item2 (a_g: separate GRID; an_i: INTEGER): CHARACTER
		do
			Result := enclosing_computers_item_fold2 (a_g.fold, an_i)
		end

	enclosing_computers_item_fold2 (a_f: separate STRING; an_i: INTEGER): CHARACTER
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

	enclosing_computers_item3 (a_g: separate GRID): INTEGER
		do
			Result := a_g.losses
		end

	enclosing_used_has_zero (a_grid: separate GRID): BOOLEAN
		do
			Result := a_grid.used.has (zero)
		end

	enclosing_calc_losses (a_grid: separate GRID; an_i: INTEGER; b_fold: STRING)
		do
			a_grid.calc_losses (an_i, an_i, b_fold)
		end

	enclosing_embed (a_grid: separate GRID; an_i: INTEGER; a_seq: BOOL_STRING; b_fold: STRING)
		do
			a_grid.embed (an_i, an_i, a_seq, b_fold)
		end

	embed (a_fold: STRING; a_seq: BOOL_STRING; an_i: INTEGER)
		local
			temp_grid, grid: separate GRID;
		do
				--	 io.put_string ("%N")
				--	 io.put_string (seq.to_string)
				--	 io.put_string ("%N")
			create grid.make (seq.count)
			temp := ""
			enclosing_embed (grid, an_i, a_seq, a_fold)
			if enclosing_used_has_zero (grid) then
				enclosing_calc_losses (grid, an_i, a_fold)
				enclosing_read_loss (grid)
				debug
					io.put_integer (loss)
				end
					--debug
			---	if computers.count > 750 then
			--		io.put_string ("%NMaximum computers hit 750%N")
			--		print_computers
			--		temp_grid := computers.item
			--		create computers.make
			--		computers.extend (temp_grid)
			--	end
					if enclosing_computers_item3 (grid) = min then
						from
							i := 1
						until
							i = enclosing_computers_item (grid)
						loop
							temp.append_character (enclosing_computers_item2 (grid, i))
							i := i + 1
						end
						debug
							io.put_string ("%Nfold: " + temp + "%N") --debug
						end
						folds.extend (temp)
						temp := ""
						losses.extend (enclosing_computers_item3 (grid))
						computers.extend (grid)
					elseif enclosing_computers_item3 (grid) < min then
						create folds.make
						create losses.make
						create computers.make
						temp := ""
						from
							i := 1
						until
							i = enclosing_computers_item (grid)
						loop
							temp.append_character (enclosing_computers_item2 (grid, i))
							i := i + 1
						end
						debug
							io.put_string ("%Nfold: " + temp + "%N") --debug
						end
						folds.extend (temp)
						temp := ""
						losses.extend (enclosing_computers_item3 (grid))
						min := enclosing_computers_item3 (grid)
						computers.extend (grid)
					--else
					--	create grid.make (seq.count)
					end

			--else
			--	create grid.make(seq.count)
			end
			--	grid.print_grid
		end -- embed

	gen_folds (a_fold: STRING; a_seq: BOOL_STRING; an_i: INTEGER)
		local
			k, j, l: INTEGER;
			c: BOOLEAN;
			temp2: STRING;
		do
				--	create c.make(1)
				--	create one.make(1)
			c := False
				--	one:=True
			j := 0
				--	 c.put_0(1)
				--	 one.put_1(1)
			embed (a_fold, a_seq, an_i)--embed first fold
			from
				k := 0
			until
				j = 1
			loop
				from
					k := a_fold.count - 1
					c := half_add (a_fold, a_fold.count)
				until
					k = 1
				loop
					if c.is_equal (one) then
						c := half_add (a_fold, k)
					end
					k := k - 1
				end
				if c.is_equal (one) then
					j := 1
				end
					--brute force enumeration of folds:
				if j = 0 then
						--grid.print_grid
						--io.put_string("%N")
					embed (a_fold, a_seq, an_i)
					debug
						temp2 := ""
						from
							l := 1
						until
							l = a_fold.count + 1
						loop
							temp2.append_character (a_fold.item (l))
								--DEBUG:
								--	io.put_integer (l)
								--	io.put_character (a_fold.item (l))
								--	io.put_string("%N")
								--
								--
								--
								--
							l := l + 1
						end
						io.put_string ("%N%Ntemp2: ")
						io.put_string (temp2)
						io.put_string ("%N")
						io.put_string ("%N%Na_fold: ")
						io.put_string (a_fold)
						io.put_string ("%N")
							--	 embed (temp, a_grid, a_seq, an_i)
						print_min_fold --debug
						io.put_string ("%N")
					end
				end
				--grid.print_grid
				--	    io.put_string("%N")
			end
		end -- gen_folds

	enclosing_put (c_fold: STRING; ch: CHARACTER; a_count: INTEGER)
		do
			c_fold.put (ch, a_count)
		end

	enclosing_item (c_fold: STRING; a_count: INTEGER): CHARACTER
		do
			Result := c_fold.item (a_count)
		end

	half_add (b_fold: STRING; count: INTEGER): BOOLEAN
		local
			b: BOOLEAN
		do
				--create b.make(1)	
			b := False
			if enclosing_item (b_fold, count) = 'N' then
				enclosing_put (b_fold, 'E', count)
					--fold.put('E', count)
					--   b.put_0(1)
				b := False
				Result := b
			elseif enclosing_item (b_fold, count) = 'E' then
				enclosing_put (b_fold, 'S', count)
					--fold.put('S', count)
					-- b.put_0(1)
				b := False
				Result := b
			elseif enclosing_item (b_fold, count) = 'S' then
				enclosing_put (b_fold, 'W', count)
					--fold.put('W', count)
					--b.put_0(1)
				b := False
				Result := b
			elseif enclosing_item (b_fold, count) = 'W' then
				enclosing_put (b_fold, 'N', count)
					--fold.put('N', count)
					--b.put_1(1)
				b := True
				Result := b
			end
		end

	print_min_fold
		do
			folds.do_all (agent print_item(?))
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

	print_item (item: STRING)
		do
			io.put_character ('#')
			io.put_integer (number)
			io.put_character (' ')
			io.put_string (item)
			io.put_character ('%N')
			number := number + 1
		end -- print_item

	print_computers
		do
			from
				computers.start
			until
				computers.exhausted
			loop
				print_computed_result (computers.item)
				computers.forth
			end
		end

	print_computed_result (a_g: separate GRID)
		local
			l: INTEGER
			temp2: STRING
		do
			io.put_string ("%Na_g.losses: ")
			io.put_integer (a_g.losses)
			io.put_character ('%N')
			io.put_string ("%Na_g.fold: ")
			temp2 := ""
			from
				l := 1
			until
				l = enclosing_computers_item (a_g)
			loop
				temp2.append_character (enclosing_computers_item2 (a_g, l))
					--DEBUG:
					--	io.put_integer (l)
					--	io.put_character (a_fold.item (l))
					--	io.put_string("%N")
					--
					--
					--
					--
				l := l + 1
			end
				--			io.put_string ("%N%N")
			io.put_string (temp2)
			io.put_string ("%N")
			io.put_character ('%N')
		end

end -- class PF_HP
