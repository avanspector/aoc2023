package day1

import "core:fmt"
import "core:mem"
import "core:strings"
import "core:time"

words := [?]string{ "zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine" }
digits := [?]string{ "0", "1", "2", "3", "4", "5", "6", "7", "8", "9" }

part1 :: proc(data: string) -> int {
	data := data
	sum := 0

	for line in strings.split_iterator(&data, "\n") {
		first, last: rune

		for c in line {
			if c >= '0' && c <= '9' {
				first = c
				break
			}
		}
		#reverse for c in line {
			if c >= '0' && c <= '9' {
				last = c
				break
			}
		}

		first_i := int(first - '0')
		last_i := int(last - '0') 
		sum += first_i * 10 + last_i
	}

	return sum
}

part2 :: proc(data: string) -> int {
	data := data
	sum := 0

	for line in strings.split_iterator(&data, "\n") {
		first, last: string
		first_i, last_i := 1000, -1

		for index in 1..<10 {
			digit := digits[index]
			str := words[index]

			i := strings.index(line, digit)
			li := strings.last_index(line, digit)
			str_i := strings.index(line, str)
			str_li := strings.last_index(line, str)
		
			min_i := min(i, str_i) if i>=0 && str_i>=0 else
			                       min(i, first_i) if i>=0 else
			                                       min(str_i, first_i) if str_i >=0 else first_i
			max_i := max(li, str_li) if li>=0 && str_li>=0 else
			                         max(li, last_i) if li>=0 else
			                                         max(str_li, last_i) if str_li >=0 else last_i

			if min_i < first_i {
				first = digit
				first_i = min_i
			}
			if max_i > last_i {
				last = digit
				last_i = max_i
			}
		}

		first_i = int(first[0] - '0')
		last_i = int(last[0] - '0') 
		sum += first_i * 10 + last_i
	}
	
	return sum	
}

main :: proc() {
	input := #load("./input.txt", string)

	arena_backing := make([]u8, 8 * mem.Megabyte)
	solution_arena: mem.Arena
	mem.arena_init(&solution_arena, arena_backing)

	alloc := mem.arena_allocator(&solution_arena)
	context.allocator = alloc

	part1_start := time.now()
	part1_ans := part1(input)
	part1_end := time.now()
	fmt.println("Part 1:", part1_ans, "Time:", time.diff(part1_start, part1_end), "Memory Used:", solution_arena.peak_used)

	free_all(context.allocator)

	part2_start := time.now()
	part2_ans := part2(input)
	part2_end := time.now()
	fmt.println("Part 2:", part2_ans, "Time:", time.diff(part2_start, part2_end), "Memory Used:", solution_arena.peak_used)

	free_all(context.allocator)
}
