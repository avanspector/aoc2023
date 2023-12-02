package day2

import "core:fmt"
import "core:mem"
import "core:strings"
import "core:strconv"
import "core:time"

part1 :: proc(data: string) -> int {
	data := data
	sum := 0
	game := 1

	for line in strings.split_iterator(&data, "\n") {
		line := line
		line = strings.trim_prefix(line[8:], ": ")
		line = strings.trim_prefix(line, " ")
		max_r, max_g, max_b: int
		count: Maybe(int)

		for word in strings.split_iterator(&line, " ") {
			if count == nil {
				count, _ = strconv.parse_int(word)
				continue
			}
			switch word[0] {
			case 'r':
				if count.? > max_r {
					max_r = count.?
				}
			case 'g':
				if count.? > max_g {
					max_g = count.?
				}
			case 'b':
				if count.? > max_b {
					max_b = count.?
				}
			case:
				panic("Wrong word of color!")
			}
			count = nil
		}

		// If the bag contained only 12 red cubes, 13 green cubes, and 14 blue cubes?
		if max_r <= 12 && max_g <= 13 && max_b <= 14 {
			sum += game
		}
		game += 1
	}

	return sum
}

part2 :: proc(data: string) -> int {
	data := data
	sum := 0

	for line in strings.split_iterator(&data, "\n") {
		line := line
		line = strings.trim_prefix(line[8:], ": ")
		line = strings.trim_prefix(line, " ")
		max_r, max_g, max_b: int
		count: Maybe(int)

		for word in strings.split_iterator(&line, " ") {
			if count == nil {
				count, _ = strconv.parse_int(word)
				continue
			}
			switch word[0] {
			case 'r':
				if count.? > max_r {
					max_r = count.?
				}
			case 'g':
				if count.? > max_g {
					max_g = count.?
				}
			case 'b':
				if count.? > max_b {
					max_b = count.?
				}
			case:
				panic("Wrong word of color!")
			}
			count = nil
		}

		sum += max_r * max_g * max_b
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
