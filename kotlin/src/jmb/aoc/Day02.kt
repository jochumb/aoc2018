package jmb.aoc

import java.io.File

fun main(args: Array<String>) {
  val lines = File("input/day02").useLines { it.toList() }
  println(part1(lines))
  println(part2(lines))
}


fun part1(lines: List<String>): Int {
  return lines.asSequence()
    .map { l -> l.groupBy { it } }
    .fold(Checksum(0,0)) { acc, chars -> acc.increment(chars) }
    .calc()
}

data class Checksum(val two: Int, val three: Int)

fun Checksum.increment(chars: Map<Char, List<Char>>): Checksum =
  this.copy(
    two = if (hasLength(chars, 2)) this.two + 1 else this.two,
    three = if (hasLength(chars, 3)) this.three + 1 else this.three)

fun Checksum.calc(): Int = this.two * this.three

private fun hasLength(chars: Map<Char, List<Char>>, length: Int) = chars.any { g -> g.value.size == length }


fun part2(lines: List<String>): String {
  lines.forEach { l1 ->
    lines.forEach { l2 ->
      val intersect = l1.toCharArray().zip(l2.toCharArray()).joinToString("") {
        p -> if (p.first == p.second) p.first.toString() else ""
      }
      if (l1.length - 1 == intersect.length) return intersect
    }
  }
  return "error"
}