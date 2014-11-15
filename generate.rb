#!/usr/bin/env ruby
require_relative 'fuzzlib'

count = weighted [
  [5, ''],
  [3, proc { (1 + rand(5)).to_s }],
  [1, proc { 10.plusMinus(5).to_s }],
  [1, proc { 40.plusMinus(20).to_s }],
]

voOnlyMotion = oneOf [
  "aw",				# VimMotionTextOuterWord
  "aW",				# VimMotionTextOuterBigWord
  "iw",				# VimMotionTextInnerWord
  "iW",				# VimMotionTextInnerBigWord
  "ip",				# VimMotionInnerParagraph
  "ap",				# VimMotionOuterParagraph
  "is",				# VimMotionInnerSentence
  "as",				# VimMotionOuterSentence
  "i<",				# VimMotionInnerBlockAngle
  "i>",				# VimMotionInnerBlockAngle
  "iB",				# VimMotionInnerBlockBrace
  "i{",				# VimMotionInnerBlockBrace
  "i}",				# VimMotionInnerBlockBrace
  "i[",				# VimMotionInnerBlockBracket
  "i]",				# VimMotionInnerBlockBracket
  "ib",				# VimMotionInnerBlockParen
  "i(",				# VimMotionInnerBlockParen
  "i)",				# VimMotionInnerBlockParen
  "i\"",     	# VimMotionInnerBlockDoubleQuote
  "i'",				# VimMotionInnerBlockSingleQuote
  "i`",				# VimMotionInnerBlockBackQuote
  "a<",				# VimMotionOuterBlockAngle
  "a>",				# VimMotionOuterBlockAngle
  "aB",				# VimMotionOuterBlockBrace
  "a{",				# VimMotionOuterBlockBrace
  "a}",				# VimMotionOuterBlockBrace
  "a[",				# VimMotionOuterBlockBracket
  "a]",				# VimMotionOuterBlockBracket
  "ab",				# VimMotionOuterBlockParen
  "a(",				# VimMotionOuterBlockParen
  "a)",				# VimMotionOuterBlockParen
  "a\"",     	# VimMotionOuterBlockDoubleQuote
  "a'",				# VimMotionOuterBlockSingleQuote
  "a`",				# VimMotionOuterBlockBackQuote
]

nvoMotion = oneOf [
  "+",				# VimMotionDownFirstNonSpace
  "_",				# VimMotionDownLess1FirstNonSpace
  #"0",				# VimMotionFirstColumn
  # "g0",				# VimMotionFirstScreenColumn
  "^",				# VimMotionFirstNonSpace
  # "g^",				# VimMotionFirstScreenNonSpace
  "gg",				# VimMotionGotoLineFirst
  "G",				# VimMotionGotoLineLast
  "$",				# VimMotionLastColumn
  # "g$",				# VimMotionLastScreenColumn
  # "g_",				# VimMotionLastNonSpace           # FIXME: broken in ideavim
  "h",				# VimMotionLeft
  "go",				# VimMotionNthCharacter
  "l",				# VimMotionRight
  "k",				# VimMotionUp
  "gk",				# VimMotionUp
  "-",				# VimMotionUpFirstNonSpace
  "ge",				# VimMotionWordEndLeft
  "e",				# VimMotionWordEndRight
  "b",				# VimMotionWordLeft
  "w",				# VimMotionWordRight
  "gE",				# VimMotionBigWordEndLeft
  "E",				# VimMotionBigWordEndRight
  "B",				# VimMotionBigWordLeft
  "W",				# VimMotionBigWordRight
  "(",				# VimMotionSentenceStartPrevious
  ")",				# VimMotionSentenceStartNext
  "g(",				# VimMotionSentenceEndPrevious
  "g)",				# VimMotionSentenceEndNext
  "{",				# VimMotionParagraphPrevious
  "}",				# VimMotionParagraphNext
  "[{",				# VimMotionUnmatchedBraceOpen
  "]}",				# VimMotionUnmatchedBraceClose
  "[(",				# VimMotionUnmatchedParenOpen
  "])",				# VimMotionUnmatchedParenClose
  "[]",				# VimMotionSectionBackwardEnd
  "[[",				# VimMotionSectionBackwardStart
  "]]",				# VimMotionSectionForwardEnd
  "][",				# VimMotionSectionForwardStart
  # "[M",				# VimMotionMethodBackwardEnd
  # "[m",				# VimMotionMethodBackwardStart
  # "]M",				# VimMotionMethodForwardEnd
  # "]m",				# VimMotionMethodForwardStart
]

voMotion = oneOf [nvoMotion, voOnlyMotion]

commandWithMotion = oneOf [
  "d",				# VimDeleteMotion
  "<",				# VimShiftLeftMotion
  ">",				# VimShiftRightMotion
  # "gu",				# VimChangeCaseLowerMotion    # XXX: disable these, since they are *extremely* slow in IdeaVim...
  # "g~",				# VimChangeCaseToggleMotion
  # "gU",				# VimChangeCaseUpperMotion
]

commandWithInput = oneOf [
  "s",				# VimChangeCharacters
  "C",				# VimChangeEndOfLine
  "cc",				# VimChangeLine
  "S",				# VimChangeLine
  "R",				# VimChangeReplace
  "a",				# VimInsertAfterCursor
  "A",				# VimInsertAfterLineEnd
  "gi",				# VimInsertAtPreviousInsert
  "I",				# VimInsertBeforeFirstNonBlank
  "gI",				# VimInsertLineStart
  "O",				# VimInsertNewLineAbove
  "o",				# VimInsertNewLineBelow
]

commandNullary = oneOf [
  "~",				# VimChangeCaseToggleCharacter
  "X",				# VimDeleteCharacterLeft
  "x",				# VimDeleteCharacterRight
  "D",				# VimDeleteEndOfLine
  "dd",				# VimDeleteLine
  "<<",				# VimShiftLeftLines
  ">>",				# VimShiftRightLines
  "gJ",				# VimDeleteJoinLines
  "J",				# VimDeleteJoinLinesSpaces
]

letter = oneOf(('a'..'z').to_a)
randomText = proc {
  20.plusMinus(15).times.map { letter[] }.join
}

command = weighted [
  [4, proc { count[] + nvoMotion[] }],
  [4, proc { count[] + commandNullary[] }],
  [2, proc { count[] + commandWithMotion[] + voMotion[] }],
  [2, proc { count[] + commandWithMotion[] + voMotion[] }],
  [2, proc { count[] + commandWithInput[] + randomText[] + '<Esc>' }],
]

20.times do
  puts command[]
end
