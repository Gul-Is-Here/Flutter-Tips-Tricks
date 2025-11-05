from __future__ import annotations

import argparse
from datetime import datetime
import re
from pathlib import Path

from fpdf import FPDF
from fpdf.enums import XPos, YPos


EMOJI_REPLACEMENTS = {
    # Strip emojis completely for a clean, professional look
    "🎯": "",
    "🌟": "",
    "🏠": "",
    "⭐": "",
    "🎨": "",
    "🚀": "",
    "🎭": "",
    "🏆": "",
    "🎪": "",
    "🎊": "",
    "📦": "",
    "💎": "",
    "🧸": "",
    "🍪": "",
    "🪄": "",
    "🧠": "",
    "🏃": "",
    "❌": "",
    "✅": "",
    "🔒": "",
    "🔄": "",
    "📱": "",
    "🎢": "",
    "🎵": "",
    "🔢": "",
    "💨": "",
    "⚡": "",
    "🌈": "",
    "🎂": "",
    "📧": "",
    "📖": "",
    "🥳": "",
    "✨": "",
    "📝": "",
    "🏭": "",
    "🧊": "",
}


def _discover_unicode_font() -> str | None:
    candidate_paths = [
        Path("/System/Library/Fonts/Supplemental/Arial Unicode.ttf"),
        Path("/Library/Fonts/Arial Unicode.ttf"),
        Path("/System/Library/Fonts/Supplemental/Arial Unicode MS.ttf"),
        Path("/System/Library/Fonts/Supplemental/DejaVuSans.ttf"),
    ]
    for path in candidate_paths:
        if path.exists():
            return str(path)
    return None


class MarkdownPDF(FPDF):
    """Simple PDF generator with basic Markdown formatting support."""

    def __init__(self) -> None:
        super().__init__(orientation="P", unit="mm", format="A4")
        self.set_auto_page_break(auto=True, margin=15)
        self.set_margins(left=20, top=20, right=20)
        # Will be set when we encounter the first H1
        self.doc_title: str | None = None
        # Colors
        self.unicode_enabled = False
        unicode_font_path = _discover_unicode_font()
        if unicode_font_path:
            self.add_font("MDUnicode", "", unicode_font_path)
            base_font = ("MDUnicode", "", 12)
            self.unicode_enabled = True
        else:
            base_font = ("Helvetica", "", 12)

        self.body_font = base_font
        self.heading_fonts = {
            1: (base_font[0], base_font[1], 20),
            2: (base_font[0], base_font[1], 16),
            3: (base_font[0], base_font[1], 14),
            4: (base_font[0], base_font[1], 12),
        }
        if self.unicode_enabled:
            self.code_font = (base_font[0], base_font[1], 10)
        else:
            self.code_font = ("Courier", "", 10)
        self.body_color = (0, 0, 0)
        self.accent_color = (0, 222, 142)
        self.set_text_color(*self.body_color)
        # Flags
        self.cover_added: bool = False
        # Add the first page after basic setup so header/footer use configured styles
        self.add_page()

    # --- Header / Footer -------------------------------------------------
    def header(self) -> None:  # type: ignore[override]
        # Top accent line
        self.set_draw_color(*self.accent_color)
        self.set_line_width(0.5)
        self.line(self.l_margin, 15, self.w - self.r_margin, 15)
        # Optional small running title on the right
        if self.doc_title:
            self.set_font(self.body_font[0], "", 9)
            self.set_text_color(*self.body_color)
            self.set_xy(self.l_margin, 8)
            # Right-aligned title snippet
            self.cell(self.w - self.l_margin - self.r_margin, 5, self._prepare_text(self.doc_title), align="R")
        # Reset cursor below the header line
        self.set_y(20)

    def footer(self) -> None:  # type: ignore[override]
        # Position 15 mm from bottom
        self.set_y(-15)
        # Accent line above footer
        self.set_draw_color(*self.accent_color)
        self.set_line_width(0.3)
        self.line(self.l_margin, self.get_y(), self.w - self.r_margin, self.get_y())
        # Page number
        self.set_font(self.body_font[0], "", 9)
        self.set_text_color(*self.body_color)
        self.set_y(-12)
        self.cell(0, 8, f"Page {self.page_no()}", align="C")

    # --- Helpers ---------------------------------------------------------
    def _section_divider(self) -> None:
        self.ln(2)
        self.set_draw_color(*self.accent_color)
        self.set_line_width(0.6)
        self.line(self.l_margin, self.get_y(), self.w - self.r_margin, self.get_y())
        self.ln(3)

    def add_cover_page(self, title: str) -> None:
        # Centered hero title with accent underline and generated date
        self.doc_title = title.strip()
        try:
            self.set_title(self._prepare_text(self.doc_title))
        except Exception:
            pass
        self.set_y(self.h * 0.35)
        # Title
        font = (self.body_font[0], "", 26)
        self.set_font(*font)
        self.set_text_color(*self.accent_color)
        prepared = self._prepare_text(self.doc_title)
        self.cell(0, 14, prepared, align="C", new_x=XPos.LMARGIN, new_y=YPos.NEXT)
        # Accent underline
        y = self.get_y()
        self.set_draw_color(*self.accent_color)
        self.set_line_width(1.2)
        self.line(self.l_margin, y, self.w - self.r_margin, y)
        # Date line
        self.ln(8)
        self.set_font(self.body_font[0], "", 11)
        self.set_text_color(*self.body_color)
        today = datetime.now().strftime("%b %d, %Y")
        self.cell(0, 8, f"Generated on {today}", align="C")
        # Start content on a new page
        self.cover_added = True
        self.add_page()

    def _draw_table_outline(self, y_top: float, y_bottom: float) -> None:
        # Draw a subtle accent outline around the table area
        if y_bottom <= y_top:
            return
        x = self.l_margin
        width = self.w - self.l_margin - self.r_margin
        height = y_bottom - y_top
        self.set_draw_color(*self.accent_color)
        self.set_line_width(0.4)
        self.rect(x, y_top - 1.5, width, height + 3)
        # Reset draw color
        self.set_draw_color(*self.body_color)

    def write_heading(self, text: str, level: int) -> None:
        # Use first H1 to generate a modern cover page
        if level == 1 and not self.cover_added:
            self.add_cover_page(text)
            return

        font = self.heading_fonts.get(level, self.heading_fonts[4])
        self.set_font(*font)
        self.set_text_color(*self.accent_color)
        prepared = self._prepare_text(text)
        if level == 1:
            # Big centered title with accent underline
            self.ln(2)
            self.cell(0, 10, prepared, new_x=XPos.LMARGIN, new_y=YPos.NEXT, align="C")
            # Accent underline
            y = self.get_y()
            self.set_draw_color(*self.accent_color)
            self.set_line_width(1.0)
            self.line(self.l_margin, y, self.w - self.r_margin, y)
            self.ln(4)
        else:
            # Left-aligned section heading with divider
            self.ln(2)
            self.multi_cell(0, 8, prepared)
            self._section_divider()
        # Reset body font
        self.set_font(*self.body_font)
        self.set_text_color(*self.body_color)

    def write_paragraph(self, text: str) -> None:
        self.set_font(*self.body_font)
        self.set_text_color(*self.body_color)
        self.multi_cell(0, 6, self._prepare_text(text))
        self.ln(1)

    def write_bullet(self, text: str) -> None:
        # Accent bullet and improved spacing/indent
        self.set_font(*self.body_font)
        bullet_char = "•" if self.unicode_enabled else "-"
        self.set_text_color(*self.accent_color)
        self.cell(5, 6, bullet_char)
        self.set_text_color(*self.body_color)
        # Indent bullet content slightly for a modern look
        x_start = self.get_x()
        self.set_x(x_start + 1)
        self.multi_cell(0, 6, self._prepare_text(text))
        self.ln(0.5)

    def write_code_block(self, lines: list[str]) -> None:
        # Draw a simple boxed code block (with page-break safety)
        self.set_font(*self.code_font)
        self.set_text_color(*self.body_color)
        usable_width = self.w - self.l_margin - self.r_margin
        line_h = 5
        padding_v = 2
        box_h = len(lines) * line_h + padding_v * 2
        x0, y0 = self.l_margin, self.get_y()
        # Page-break safety: move to next page if needed
        max_y = self.h - self.b_margin
        if y0 + box_h > max_y:
            self.add_page()
            x0, y0 = self.l_margin, self.get_y()
        # Border in black, no fill (white background)
        self.set_draw_color(*self.body_color)
        self.set_line_width(0.2)
        self.rect(x0, y0, usable_width, box_h)
        # Text with small left/top padding
        self.set_xy(x0 + 2, y0 + padding_v)
        for idx, line in enumerate(lines):
            cleaned = self._prepare_text(line.rstrip())
            self.multi_cell(usable_width - 4, line_h, cleaned)
            if idx < len(lines) - 1:
                self.set_x(x0 + 2)
        # Move cursor to the end of the box
        self.set_xy(x0, y0 + box_h + 2)
        self.set_font(*self.body_font)

    def write_table_row(self, columns: list[str], is_header: bool = False) -> None:
        font_name = self.body_font[0]
        font_style = "B" if (is_header and not self.unicode_enabled) else self.body_font[1]
        font = (font_name, font_style, 11)
        self.set_font(*font)
        # Header: black text on accent fill; Body: black text, normal fill
        if is_header:
            self.set_text_color(*self.body_color)
            self.set_fill_color(*self.accent_color)
            self.set_draw_color(*self.accent_color)
        else:
            self.set_text_color(*self.body_color)
            self.set_fill_color(255, 255, 255)
            self.set_draw_color(*self.body_color)
        col_width = (self.w - self.l_margin - self.r_margin) / len(columns)
        for col in columns:
            label = self._prepare_text(col)
            self.multi_cell(
                col_width,
                8,
                label,
                border=1,
                align="C",
                new_x=XPos.RIGHT,
                new_y=YPos.TOP,
                fill=is_header,
            )
        self.ln(8)
        # Reset styles
        self.set_font(*self.body_font)
        self.set_text_color(*self.body_color)
        self.set_draw_color(*self.body_color)

    def _prepare_text(self, text: str) -> str:
        cleaned = text.strip()
        for emoji, replacement in EMOJI_REPLACEMENTS.items():
            cleaned = cleaned.replace(emoji, replacement)
        cleaned = cleaned.replace("️", "")
        cleaned = cleaned.replace("*", "")
        cleaned = cleaned.replace("#", "")
        if self.unicode_enabled:
            return cleaned
        return cleaned.encode("latin-1", "ignore").decode("latin-1")


def parse_markdown(content: str, pdf: MarkdownPDF) -> None:
    code_mode = False
    code_lines: list[str] = []
    table_mode = False
    table_header_consumed = False
    table_top_y: float | None = None

    lines = content.splitlines()
    for raw_line in lines:
        line = raw_line.rstrip()

        if line.strip().startswith("```"):
            if code_mode:
                pdf.write_code_block(code_lines)
                code_lines = []
            code_mode = not code_mode
            continue

        if code_mode:
            code_lines.append(line)
            continue

        if line.startswith("|") and line.endswith("|"):
            columns = [col.strip() for col in line.split("|") if col.strip()]
            if columns and all(set(col) <= {"-"} for col in columns):
                continue
            if not table_mode:
                table_mode = True
                table_header_consumed = False
                table_top_y = pdf.get_y()
            pdf.write_table_row(columns, is_header=not table_header_consumed)
            table_header_consumed = True
            continue
        elif table_mode:
            table_mode = False
            table_header_consumed = False
            # Draw an outline around the just-finished table area
            if table_top_y is not None:
                pdf._draw_table_outline(table_top_y, pdf.get_y())
                table_top_y = None
            pdf.ln(4)

        heading_match = re.match(r"^(#{1,6})\\s+(.*)$", line)
        if heading_match:
            hashes, heading_text = heading_match.groups()
            level = len(hashes)
            pdf.write_heading(heading_text, level)
            continue

        list_match = re.match(r"^[-*+]\\s+(.*)$", line)
        if list_match:
            pdf.write_bullet(list_match.group(1))
            continue

        if not line.strip():
            pdf.ln(3)
            continue

        pdf.write_paragraph(line)


def main() -> None:
    parser = argparse.ArgumentParser(description="Convert Markdown to PDF.")
    parser.add_argument("input", type=Path, help="Markdown input file")
    parser.add_argument("output", type=Path, help="Destination PDF path")

    args = parser.parse_args()

    if not args.input.exists():
        raise SystemExit(f"Input file {args.input} does not exist")

    content = args.input.read_text(encoding="utf-8")
    pdf = MarkdownPDF()
    parse_markdown(content, pdf)
    pdf.output(str(args.output))


if __name__ == "__main__":
    main()
