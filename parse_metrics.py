fid = 0
ssim = 0
count = 0

with open("metrics.txt", "r") as file:
    for line in file:
        if ',' in line: continue
        elif line.startswith('FID'):
            fid += float(line.split(" ")[-1].strip())
        else:
            ssim += float(line)
            count += 1

fid /= count
ssim /= count
print(f"FID: {fid:.2f}")
print(f"SSIM: {100 * ssim:.2f}")
