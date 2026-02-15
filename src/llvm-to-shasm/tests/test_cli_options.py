from llvm_to_shasm.cli import _decode_sheet_cell, build_parser
from llvm_to_shasm.compiler import default_assembler_path


def test_default_assembler_path_standard() -> None:
    assert default_assembler_path(celly=False).name == "assembler.js"


def test_default_assembler_path_celly() -> None:
    assert default_assembler_path(celly=True).name == "celly_assembler.js"


def test_cli_parses_celly_flag() -> None:
    parser = build_parser()
    args = parser.parse_args(["tests/fixtures/fib.c", "--sheet-out", "out.sheet", "--celly"])
    assert args.celly is True


def test_decode_sheet_cell_round_trip_example() -> None:
    assert _decode_sheet_cell("[ !  \"! 5! 4#]") == [4, 9, 85, 83]
