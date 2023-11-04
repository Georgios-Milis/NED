import re
import numpy as np
import matplotlib.pyplot as plt


# Define regular expressions to match the loss lines
loss_patterns = {
    "D_fake": r"D_fake: (\d+\.\d+)",
    "D_real": r"D_real: (\d+\.\d+)",
    "Dm_fake": r"Dm_fake: (\d+\.\d+)",
    "Dm_real": r"Dm_real: (\d+\.\d+)",
    "G_GAN": r"G_GAN: (\d+\.\d+)",
    "G_GAN_Feat": r"G_GAN_Feat: (\d+\.\d+)",
    "G_VGG": r"G_VGG: (\d+\.\d+)",
    "Gm_GAN": r"Gm_GAN: (\d+\.\d+)",
    "Gm_GAN_Feat": r"Gm_GAN_Feat: (\d+\.\d+)",
}

# Initialize dictionaries to store loss values
loss_data = {loss: [] for loss in loss_patterns}

# Open and read the log file
with open('/home/gmil/NED/renderer_checkpoints/55F_3/loss_log.txt', 'r') as file:
    lines = file.readlines()

# Parse the log file
for line in lines:
    for loss, pattern in loss_patterns.items():
        match = re.search(pattern, line)
        if match:
            loss_value = float(match.group(1))
            loss_data[loss].append(loss_value)

# Define the window size for the moving average filter
window_size = 20

# Create subplots for D, Dm, G, and Gm losses
loss_categories = ["D_", "Dm_", "G_", "Gm_"]

fig, axs = plt.subplots(2, 2, figsize=(12, 8))
fig.suptitle('Filtered Losses Over Iterations', fontsize=16)

for i, category in enumerate(loss_categories):
    ax = axs[i // 2, i % 2]
    for loss in loss_data.keys():
        if category in loss:
            values = loss_data[loss]
            filtered_values = np.convolve(values, np.ones(window_size) / window_size, mode='valid')
            ax.plot(filtered_values, label=loss)

    ax.set_xlabel('Iteration')
    ax.set_ylabel('Loss Value (Filtered)')
    ax.set_title(f'{category} Losses')
    ax.legend()
    ax.grid()

plt.tight_layout()
plt.subplots_adjust(top=0.9)
plt.savefig("losses_55F.png", bbox_inches="tight")
