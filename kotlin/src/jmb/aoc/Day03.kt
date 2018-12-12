package jmb.aoc

import java.io.File

fun main(args: Array<String>) {
    val claims = File("input/day03").useLines { it.toList() }.map(::parseClaim)
    println(d3p1(claims))
    println(d3p2(claims))
}

fun parseClaim(claim: String): Claim {
    val split = claim.split("#"," ","@",",",":","x")
    return Claim(split[1].toInt(),split[4].toInt(),split[5].toInt(),split[7].toInt(),split[8].toInt())
}

fun d3p1(claims: List<Claim>): Int {
    return claims.asSequence().map(::area).flatten().groupingBy { it }.eachCount().asSequence().filter { it.value >= 2 }.count()
}

fun d3p2(claims: List<Claim>): Int {
    val areas = claims.map(::area)
    return claims.asSequence().first {
        val cur = area(it)
        areas.all { a -> a == cur || a.intersect(cur).isEmpty() }
    }.id
}

fun area(claim: Claim): Set<Point> {
    return IntRange(claim.x+1, claim.x+claim.xd)
        .flatMap { x -> IntRange(claim.y+1, claim.y+claim.yd).map { y -> Point(x,y) } }.toSet()
}

data class Claim(val id: Int, val x: Int, val y: Int, val xd: Int, val yd: Int)
