#!/usr/bin/env ruby
require_relative 'fuzzlib'

b = true
ENABLE_SCREEN_RELATIVE = b
ENABLE_EXTRA_MOTIONS = b

count = weighted [
  [5, ''],
  [3, proc { (1 + rand(5)).to_s }],
  [1, proc { 10.plusMinus(5).to_s }],
  [1, proc { 40.plusMinus(20).to_s }],
]

voOnlyMotion = oneOf([
  "0",        # VimMotionFirstColumn
  "aw",       # VimMotionTextOuterWord
  "aW",       # VimMotionTextOuterBigWord
  "iw",       # VimMotionTextInnerWord
  "iW",       # VimMotionTextInnerBigWord
  "ip",       # VimMotionInnerParagraph
  "ap",       # VimMotionOuterParagraph
] + enableIf(ENABLE_EXTRA_MOTIONS, [
  "is",       # VimMotionInnerSentence        # minor bugs
  "as",       # VimMotionOuterSentence        # minor bugs

  "i<",       # VimMotionInnerBlockAngle
  "i>",       # VimMotionInnerBlockAngle
  "iB",       # VimMotionInnerBlockBrace
  "i{",       # VimMotionInnerBlockBrace
  "i}",       # VimMotionInnerBlockBrace
  "i[",       # VimMotionInnerBlockBracket
  "i]",       # VimMotionInnerBlockBracket
  "ib",       # VimMotionInnerBlockParen
  "i(",       # VimMotionInnerBlockParen
  "i)",       # VimMotionInnerBlockParen
  "i\"",      # VimMotionInnerBlockDoubleQuote
  "i'",       # VimMotionInnerBlockSingleQuote
  "i`",       # VimMotionInnerBlockBackQuote
  "a<lt>",    # VimMotionOuterBlockAngle
  "a>",       # VimMotionOuterBlockAngle
  "aB",       # VimMotionOuterBlockBrace
  "a{",       # VimMotionOuterBlockBrace
  "a}",       # VimMotionOuterBlockBrace
  "a[",       # VimMotionOuterBlockBracket
  "a]",       # VimMotionOuterBlockBracket
  "ab",       # VimMotionOuterBlockParen
  "a(",       # VimMotionOuterBlockParen
  "a)",       # VimMotionOuterBlockParen
  "a\"",      # VimMotionOuterBlockDoubleQuote
  "a'",       # VimMotionOuterBlockSingleQuote
  "a`",       # VimMotionOuterBlockBackQuote
]))

nvoMotion = oneOf([
  "h",        # VimMotionLeft
  "j",        # VimMotionDown
  "k",        # VimMotionUp
  "l",        # VimMotionRight

  "go",       # VimMotionNthCharacter
  "|",        # VimMotionColumn
  "^",        # VimMotionFirstNonSpace
  "$",        # VimMotionLastColumn
  "g_",       # VimMotionLastNonSpace           # FIXME: broken in ideavim


  "gg",       # VimMotionGotoLineFirst
  "G",        # VimMotionGotoLineLast
  "_",        # VimMotionDownLess1FirstNonSpace # FIXME
  "+",        # VimMotionDownFirstNonSpace      # FIXME
  "-",        # VimMotionUpFirstNonSpace        # FIXME

  "ge",       # VimMotionWordEndLeft
  "e",        # VimMotionWordEndRight
  "b",        # VimMotionWordLeft
  "w",        # VimMotionWordRight
  "gE",       # VimMotionBigWordEndLeft
  "E",        # VimMotionBigWordEndRight
  "B",        # VimMotionBigWordLeft
  "W",        # VimMotionBigWordRight

  # missing searches: tTfF /? *# g* g#
] + enableIf(ENABLE_EXTRA_MOTIONS, [
  "(",        # VimMotionSentenceStartPrevious  # too far from Vim behaviour
  ")",        # VimMotionSentenceStartNext      # too far from Vim behaviour
  "g(",       # VimMotionSentenceEndPrevious    # too far from Vim behaviour
  "g)",       # VimMotionSentenceEndNext        # too far from Vim behaviour
  "{",        # VimMotionParagraphPrevious      # too far from Vim behaviour
  "}",        # VimMotionParagraphNext          # too far from Vim behaviour
  "[{",       # VimMotionUnmatchedBraceOpen     # too far from Vim behaviour
  "]}",       # VimMotionUnmatchedBraceClose    # too far from Vim behaviour
  "[(",       # VimMotionUnmatchedParenOpen     # too far from Vim behaviour
  "])",       # VimMotionUnmatchedParenClose    # too far from Vim behaviour
  "[]",       # VimMotionSectionBackwardEnd     # buggy
  "[[",       # VimMotionSectionBackwardStart   # buggy
  "]]",       # VimMotionSectionForwardEnd      # buggy
  "][",       # VimMotionSectionForwardStart    # buggy
  "[M",       # VimMotionMethodBackwardEnd
  "[m",       # VimMotionMethodBackwardStart
  "]M",       # VimMotionMethodForwardEnd
  "]m",       # VimMotionMethodForwardStart
]) + enableIf(NABLE_SCREEN_RELATIVE, [
  "g0",       # VimMotionFirstScreenColumn
  "g^",       # VimMotionFirstScreenNonSpace
  "gm",       # VimMotionMiddleColumn
  "g$",       # VimMotionLastScreenColumn

  "%",        # VimMotionPercentOrMatch
  "H",        # VimMotionFirstScreenLine
  "M",        # VimMotionMiddleScreenLine
  "L",        # VimMotionLastScreenLine

  "zl",       # VimMotionScrollColumnLeft
  "zh",       # VimMotionScrollColumnRight

  "zt",       # VimMotionScrollFirstScreenLine
  "zs",       # VimMotionScrollFirstScreenColumn
  "z+",       # VimMotionScrollFirstScreenLinePageStart
  "zb",       # VimMotionScrollLastScreenLine
  "ze",       # VimMotionScrollLastScreenColumn
  "z-",       # VimMotionScrollLastScreenLineStart
  "z^",       # VimMotionScrollLastScreenLinePageStart
  "z<CR>",    # VimMotionScrollFirstScreenLineStart
  "<C-D>",    # VimMotionScrollHalfPageDown
  "<C-U>",    # VimMotionScrollHalfPageUp
  "<C-E>",    # VimMotionScrollLineDown
  "<C-Y>",    # VimMotionScrollLineUp
  "<C-F>",    # VimMotionScrollPageDown
  "<C-B>",    # VimMotionScrollPageUp
  "<C-H>",    # VimMotionLeftWrap
]))

voMotion = oneOf [nvoMotion, voOnlyMotion]

commandWithMotion = oneOf [
  "d",        # VimDeleteMotion
  "<lt>",     # VimShiftLeftMotion          # these are a bit boring
  ">",        # VimShiftRightMotion           # these are a bit boring
  # "gu",     # VimChangeCaseLowerMotion    # XXX: disable these, since they are *extremely* slow in IdeaVim...
  # "g~",     # VimChangeCaseToggleMotion
  # "gU",     # VimChangeCaseUpperMotion

  # missing yanks: y
]

commandWithInput = oneOf [
  "s",        # VimChangeCharacters
  "C",        # VimChangeEndOfLine
  "cc",       # VimChangeLine
  "S",        # VimChangeLine
  "R",        # VimChangeReplace
  "a",        # VimInsertAfterCursor
  "A",        # VimInsertAfterLineEnd
  "gi",       # VimInsertAtPreviousInsert
  "I",        # VimInsertBeforeFirstNonBlank
  "gI",       # VimInsertLineStart
  "O",        # VimInsertNewLineAbove
  "o",        # VimInsertNewLineBelow
]

commandNullary = oneOf [
  "~",        # VimChangeCaseToggleCharacter
  "X",        # VimDeleteCharacterLeft
  "x",        # VimDeleteCharacterRight
  # "D",      # VimDeleteEndOfLine      # TODO: fix
  "dd",       # VimDeleteLine
  "<<",       # VimShiftLeftLines
  ">>",       # VimShiftRightLines
  "gJ",       # VimDeleteJoinLines
  "J",        # VimDeleteJoinLinesSpaces
  "<C-A>",    # VimChangeNumberInc
  "<C-X>",    # VimChangeNumberDec
  # missing pastes: p P gp gP ]p [p ]P [P
  # missing: yy Y
]

# missing: r<char> u U C-R & g& =
# missing marks: m ` ' g` g'
# missing: macros

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
