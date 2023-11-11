fid = 0
ssim = 0
cpbd = 0
count = 0

with open("metrics.txt", "r") as file:
    for line in file:
        if line.startswith('FID'):
            fid += float(line.split(" ")[-1].strip())
            count += 1
        elif line.startswith('SSIM'):
            ssim += float(line.split(" ")[-1].strip().replace('%', ''))
        elif line.startswith('CPBD'):
            cpbd += float(line.split(" ")[-1].strip())
            

fid /= count
ssim /= count
cpbd /= count
print(f"FID: {fid:.2f}")
print(f"SSIM: {ssim:.2f}")
print(f"CPBD: {cpbd:.4f}")
