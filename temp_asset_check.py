import re
from pathlib import Path
root = Path(r'D:/VScode/NIKE-9983584dfa1583837817fe398b9f187290997c93')
file = root / 'lib' / 'data' / 'local_product_data.dart'
text = file.read_text(encoding='utf-8')
fixes = []
missing = []
for m in re.finditer(r"imageUrl:\s*'([^']+)'", text):
    rel = m.group(1)
    full = root.joinpath(*Path(rel).parts)
    if full.exists():
        continue
    stem = Path(rel).stem
    dirp = root.joinpath(*Path(rel).parent.parts)
    cand = None
    for ext in ['.jpg', '.png', '.avif']:
        candidate = dirp / (stem + ext)
        if candidate.exists():
            cand = candidate
            break
    if cand:
        fixes.append((rel, str(cand.relative_to(root)).replace('\\', '/')))
    else:
        missing.append(rel)
print('FIXES', len(fixes))
for old, new in fixes:
    print(old + ' => ' + new)
print('MISSING', len(missing))
for rel in missing:
    print('MISSING', rel)
