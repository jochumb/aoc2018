package jmb.aoc

import java.io.File

fun main(args: Array<String>) {
  val lines = File("input/day01").useLines { it.toList() }.map { it.toInt() }
  println(lines.sum())
  println(part2(lines.toMutableList()))
}

fun part2(lines: MutableList<Int>): Int {
  var i = 0
  var sum = 0
  var seen = mutableSetOf(sum)
  while (true) {
    val next = lines[i++]
    sum += next
    if (sum in seen) return sum
    seen.add(sum)
    lines.add(next)
  }
}


