import re
from pathlib import Path

root = Path(r'D:/VScode/NIKE-9983584dfa1583837817fe398b9f187290997c93')
file_path = root / 'lib' / 'data' / 'local_product_data.dart'
text = file_path.read_text(encoding='utf-8')

pattern = re.compile(r"'(assets/[^']+)'")
missing = []
updated = []


def replace_path(match):
    original = match.group(0)
    rel_path = match.group(1)
    asset_path = root.joinpath(*Path(rel_path).parts)

    if asset_path.exists():
        return original

    parent = asset_path.parent
    stem = asset_path.stem
    found = None

    if parent.exists():
        for ext in ['.jpg', '.png', '.avif']:
            candidate = parent / f'{stem}{ext}'
            if candidate.exists():
                found = candidate
                break

    if found:
        new_rel = str(found.relative_to(root)).replace('\\', '/')
        updated.append((rel_path, new_rel))
        return f"'{new_rel}'"

    missing.append(rel_path)
    return original

new_text = pattern.sub(replace_path, text)

if updated:
    file_path.write_text(new_text, encoding='utf-8')
    print(f'Updated {len(updated)} asset paths:')
    for old, new in updated:
        print(old, '=>', new)
else:
    print('No updates needed.')

if missing:
    print(f'Missing {len(missing)} asset paths:')
    for rel in missing:
        print(rel)
