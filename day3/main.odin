package day3

import "core:fmt"
import "core:mem"
import "core:strings"
import "core:strconv"
import "core:time"

part1 :: proc(data: string) -> int {
	data := data
	sum := 0
	line_len := strings.index(data, "\n") + 1

	text_loop: for i := 0; i < len(data); {
		if !(data[i] >= '0' && data[i] <= '9') {
			i += 1
			continue
		}

		num, _  := strconv.parse_int(data[i:])
		num_len := 3 if num >= 100 else 2 if num >= 10 else 1

		if i+num_len < len(data) {
			if data[i+num_len] != '.' && data[i+num_len] != '\n' {
				sum += num
				i += num_len
				continue
			}
		}
		if i-1 >= 0 {
			if data[i-1] != '.' && data[i-1] != '\n' {
				sum += num
				i += num_len
				continue
			}
		}

		if i+line_len < len(data) {
			for idx in 0..=num_len+1 {
				sym := data[i+line_len+idx-1]
				if !(sym >= '0' && sym <= '9') && sym != '.' && sym != '\n' {
					sum +=num
					i += num_len
					continue text_loop
				} 
			}
		}
		if i-line_len >= 0 {
			for idx in 0..=num_len+1 {
				sym := data[i-line_len+idx-1]
				if !(sym >= '0' && sym <= '9') && sym != '.' && sym != '\n' {
					sum +=num
					i += num_len
					continue text_loop
				} 
			}
		}

		i += num_len
	}

	return sum
}

part2 :: proc(data: string) -> int {
	data := data
	sum := 0
	line_len := strings.index(data, "\n") + 1

	for i := line_len; i < len(data)-line_len; {
		if data[i] != '*' {
			i += 1
			continue
		}

		nums_pos: [6]enum{
			None,
			Left,
			Right,
			Top,
			Top_Left,
			Top_Right,
			Bottom,
			Bottom_Left,
			Bottom_Right,
		}

		nums_count := 0

		// There is always a sufficient amount of space for 3 digit number to 
		// appear from any side (allows to skip a lot of cumbersome checks).
		// Also no stars appear on the first and the last lines of the input file.

		if data[i-1] >= '0' && data[i-1] <= '9' {
			nums_pos[nums_count] = .Left
			nums_count += 1
		}
		
		if data[i+1] >= '0' && data[i+1] <= '9' {
			nums_pos[nums_count] = .Right
			nums_count += 1
		}

		if data[i-line_len] >= '0' && data[i-line_len] <= '9' {
			nums_pos[nums_count] = .Top
			nums_count += 1
		} else {
			if data[i-line_len-1] >= '0' && data[i-line_len-1] <= '9' {
				nums_pos[nums_count] = .Top_Left
				nums_count += 1
			}
			if data[i-line_len+1] >= '0' && data[i-line_len+1] <= '9' {
				nums_pos[nums_count] = .Top_Right
				nums_count += 1
			}
		}

		if data[i+line_len] >= '0' && data[i+line_len] <= '9' {
			nums_pos[nums_count] = .Bottom
			nums_count += 1
		} else {
			if data[i+line_len-1] >= '0' && data[i+line_len-1] <= '9' {
				nums_pos[nums_count] = .Bottom_Left
				nums_count += 1
			}
			if data[i+line_len+1] >= '0' && data[i+line_len+1] <= '9' {
				nums_pos[nums_count] = .Bottom_Right
				nums_count += 1
			}
		}

		if nums_count != 2 {
			// Minimal distance between two neighbouring stars. 
			i += 3
			continue
		}

		nums: [2]int

		for &num, idx in nums {
			switch nums_pos[idx] {
			case .Left:
				num_len := 0
				for data[i-1-num_len] >= '0' && data[i-1-num_len] <= '9' {
					num_len += 1
				}
				num, _ = strconv.parse_int(data[i-num_len:])

			case .Right:
				num, _ = strconv.parse_int(data[i+1:])

			case .Top:
				off := 0
				for data[i-line_len-1-off] >= '0' && data[i-line_len-1-off] <= '9' {
					off += 1
				}
				num, _ = strconv.parse_int(data[i-line_len-off:])

			case .Top_Left:
				num_len := 0
				for data[i-line_len-1-num_len] >= '0' && data[i-line_len-1-num_len] <= '9' {
					num_len += 1
				}
				num, _ = strconv.parse_int(data[i-line_len-num_len:])

			case .Top_Right:
				num, _ = strconv.parse_int(data[i-line_len+1:])

			case .Bottom:
				off := 0
				for data[i+line_len-1-off] >= '0' && data[i+line_len-1-off] <= '9' {
					off += 1
				}
				num, _ = strconv.parse_int(data[i+line_len-off:])

			case .Bottom_Left:
				num_len := 0
				for data[i+line_len-1-num_len] >= '0' && data[i+line_len-1-num_len] <= '9' {
					num_len += 1
				}
				num, _ = strconv.parse_int(data[i+line_len-num_len:])

			case .Bottom_Right:
				num, _ = strconv.parse_int(data[i+line_len+1:])

			case .None:
				unreachable()
			}
		}

		sum += nums[0] * nums[1]

		i += 3
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
