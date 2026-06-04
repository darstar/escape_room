#%%
import numpy as np
import matplotlib.pyplot as plt

# Adjusted color values to valid web hex formats for Matplotlib
colors = {
    'background': '#1A3059',
    'orange': '#E34D25',
    'warning': '#B71C1C',
    'text': '#F8FAFC',        # Off-white for readable labels
    'grid': '#94A3B8',        # Muted grey for subtle grid lines
}

# Configure clean styles for dark mode diagnostic screens
plt.rcParams['text.usetex'] = False
plt.rcParams['font.size'] = 10

# Background Colors (Both canvas and inner plot area)
plt.rcParams['figure.facecolor'] = colors['background']
plt.rcParams['axes.facecolor'] = colors['background']

# Standard Plot Color (Sets default color for lines, scatter plots, etc.)
plt.rcParams['axes.prop_cycle'] = plt.cycler(color=[colors['orange']])

# Label, Text, and Border Colors
plt.rcParams['text.color'] = colors['text']
plt.rcParams['axes.labelcolor'] = colors['text']
plt.rcParams['xtick.color'] = colors['text']
plt.rcParams['ytick.color'] = colors['text']
plt.rcParams['axes.edgecolor'] = colors['grid']

# Grid Customization
plt.rcParams['axes.grid'] = True
plt.rcParams['grid.color'] = colors['grid']
plt.rcParams['grid.alpha'] = 0.2
plt.rcParams['grid.linestyle'] = '--'
#%%
# Time vector: 4 seconds total
t = np.linspace(0, 4, 400)
np.random.seed(42)  # Ensures noise remains consistent per run

# ----- User-tunable motor constant (Nm/A) -----
# Adjust Kt to tune how much current is required for a given torque
Kt = 0.11

# Physical parameters for a ~10 kg leg
m_leg = 10.0            # kg
l_leg = 0.45            # m (approximate segment length)
l_cog = 0.5 * l_leg     # distance to center of mass (approx)
g = 9.81

# =========================================================================
# 1. REFERENCE SHEET DATA (Realistic knee gait, torque, current)
# =========================================================================
# Construct a reasonably realistic knee angle waveform: small extension at
# heel-strike and larger flexion during swing. Use a half-wave asymmetry
# to mimic stance/swing differences.
fund = np.sin(2 * np.pi * 0.5 * t + np.pi / 4.0)  # fundamental (0.5 Hz gait) phase-shifted by pi/4
harm = 0.4 * np.sin(2 * np.pi * 1.5 * t)          # higher harmonic for shape

# Half-wave enhancement for swing phase (when fund>0)
swing_boost = np.where(fund > 0, fund ** 1.0, 0.4 * np.abs(fund))

# knee angle in degrees (rough range: 0 deg = full extension, ~60 deg = max flexion)

# add a small low-frequency shared jitter so anomalies are less obvious
shared_jitter = 0.6 * np.sin(2 * np.pi * 0.2 * t) + np.random.normal(0, 0.03, len(t))

ref_knee_angle = 5.0 + 45.0 * swing_boost + 6.0 * harm
ref_knee_angle += 2.0 * shared_jitter
ref_knee_angle = np.clip(ref_knee_angle, 0.0, 75.0)

# Angular kinematics
theta_rad = np.deg2rad(ref_knee_angle)
omega = np.gradient(theta_rad, t)            # rad/s
alpha = np.gradient(omega, t)                # rad/s^2

# Simple dynamic model: torque = I*alpha + m*g*l_cog*sin(theta) + damping
I = m_leg * (l_leg ** 2) / 3.0                # approximate moment of inertia
torque_inertia = I * alpha
torque_gravity = m_leg * g * l_cog * np.sin(theta_rad)
damping = 0.2 * omega


ref_torque = torque_inertia + torque_gravity + damping
# small measurement noise and shared low-frequency jitter to obscure faults
ref_torque += np.random.normal(0, 0.4, len(t)) + 1.2 * shared_jitter
ref_torque = np.clip(ref_torque, 0.0, 80.0)

# Current derived from torque via motor constant Kt (plus frictional current and noise)
ref_current = ref_torque / (Kt*101)
ref_current += 0.3 * omega * 5.0  # scale velocity-dependent current term (friction/viscous)
ref_current += np.random.normal(0, 1.0, len(t))
ref_current = np.clip(ref_current, 0.0, 120.0)

fig, axs = plt.subplots(3, 1, figsize=(7, 9), sharex=True)

axs[0].plot(t, ref_knee_angle, color=colors['orange'], lw=1.5)
axs[0].set_title("Reference Profile: Knee Angle (deg)")
axs[0].set_ylabel("Angle (deg)")
axs[0].set_ylim(-10, 80)

axs[1].plot(t, ref_current, color=colors['orange'], lw=1.5)
axs[1].set_title("Reference Profile: Motor Current (A)")
axs[1].set_ylabel("Current (A)")
# axs[1].set_ylim(0, 130)

axs[2].plot(t, ref_torque, color=colors['orange'], lw=1.5)
axs[2].set_title("Reference Profile: Knee Torque (Nm)")
axs[2].set_ylabel("Torque (Nm)")
axs[2].set_xlabel("Time (s)")
axs[2].set_ylim(0, 90)

plt.tight_layout()
plt.savefig('reference.png', dpi=300)



# =========================================================================
# 2. TELEMETRY CARD A (ANGULAR DIAGNOSTIC)
# =========================================================================
# Create a slightly phase-shifted diagnostic stream for angle
fund_disturbed = np.sin(2 * np.pi * 0.5 * t + np.pi / 2.0)
harm_disturbed = 0.4 * np.sin(2 * np.pi * 1.5 * t + np.pi / 4.0)  # matching shift on the harmonic

# Reapply identical swing boost logic using the shifted base
swing_boost_disturbed = np.where(fund_disturbed > 0, fund_disturbed ** 1.0, 0.4 * np.abs(fund_disturbed))

# Re-build using identical structural coefficients and shared jitter
diag_angle = 5.0 + 45.0 * swing_boost_disturbed + 6.0 * harm_disturbed
diag_angle += 2.0 * shared_jitter
diag_angle = np.clip(diag_angle, 0.0, 75.0)

# Normalize using expected physical boundaries (-10 to 80 deg) for the UI output range mapping
norm_diag_angle = (diag_angle - (-10.0)) / (80.0 - (-10.0))

fig, ax = plt.subplots(figsize=(6, 3.5))
ax.plot(t, norm_diag_angle, color=colors['orange'], lw=1.5)
ax.set_title("Data Packet 0X4A", fontsize=11, fontweight='bold')
ax.set_xlabel("Time (s)")
ax.set_ylim(-0.1, 1.1)
plt.tight_layout()
plt.savefig('card_a.png', dpi=300)

# =========================================================================
# 3. TELEMETRY CARD B (TORQUE DIAGNOSTIC)
# =========================================================================
# Use the reference torque but add transient spikes and noise for diagnostics
bad_torque = ref_torque.copy()
spike_zone1 = (t >= 0.85) & (t <= 1.2)
spike_zone2 = (t >= 2.85) & (t <= 3.2)

# make spikes less conspicuous
bad_torque[spike_zone1] += 6.0 * np.sin((t[spike_zone1] - 0.85) / (1.2 - 0.85) * np.pi)
bad_torque[spike_zone2] += 6.0 * np.sin((t[spike_zone2] - 2.85) / (3.2 - 2.85) * np.pi)
bad_torque += np.random.normal(0, 0.6, len(t)) + 0.4 * shared_jitter
bad_torque_clipped = np.clip(bad_torque, 0.0, 90.0)
norm_bad_torque = (bad_torque_clipped - 0.0) / (90.0 - 0.0)

max_spike = np.where(norm_bad_torque > 0.2)
norm_bad_torque[max_spike] = np.nan
norm_bad_torque[spike_zone1] = np.nan
norm_bad_torque[spike_zone2] = np.nan

fig, ax = plt.subplots(figsize=(6, 3.5))
ax.plot(t, norm_bad_torque, color=colors['orange'], lw=1.5)
ax.set_title("Data Packet 0X4B", fontsize=11, fontweight='bold')
ax.set_xlabel("Time (s)")
ax.set_ylabel("Corrupted Value (0.0 - 1.0)")
ax.set_ylim(-0.1, 1.1)
plt.tight_layout()
plt.savefig('card_b.png', dpi=300)



# =========================================================================
# 4. TELEMETRY CARD C (CURRENT DIAGNOSTIC)
# =========================================================================
# Current derived from the noisy torque and Kt, include clipping to mimic
# bus saturation and supply limits
bad_current = bad_torque_clipped / Kt
# add velocity-dependent current and noise, plus subtle shared jitter
bad_current += 0.18 * np.abs(omega) * 40.0
bad_current += np.random.normal(0, 0.5, len(t)) + 0.15 * shared_jitter * 50.0
# simulate occasional hardware saturation (kept slightly lower to avoid obvious clipping)
bad_current = np.clip(bad_current, 0.0, 105.0)
norm_bad_current = bad_current / 120.0

fig, ax = plt.subplots(figsize=(6, 3.5))
ax.plot(t, norm_bad_current, color=colors['orange'], lw=1.5)
ax.set_title("Data Packet 0X4C", fontsize=11, fontweight='bold')
ax.set_xlabel("Time (s)")
ax.set_ylabel("Corrupted Value (0.0 - 1.0)")
ax.set_ylim(-0.1, 1.1)
ax.text(2.0, 1.02, "BUS SATURATION LIMIT DETECTED", color=colors['warning'], fontsize=8, ha='center', alpha=0.9)
plt.tight_layout()
plt.savefig('card_c.png', dpi=300)



# =========================================================================
# 5. TELEMETRY CARD D (RED HERRING - GHOST NOISE)
# =========================================================================
ghost_noise = np.random.normal(0.5, 0.14, len(t))
ghost_noise += 0.08 * np.sin(2 * np.pi * 1.8 * t)  # deceptive ripple
# add a faint shared component so ghost bus sometimes echoes real channels
ghost_noise += 0.12 * shared_jitter
norm_ghost_data = np.clip(ghost_noise, 0, 1.0)

fig, ax = plt.subplots(figsize=(6, 3.5))
ax.plot(t, norm_ghost_data, color=colors['orange'], lw=1.5)
ax.set_title("Data Packet 0X4D", fontsize=11, fontweight='bold')
ax.set_xlabel("Time (s)")
ax.set_ylabel("Corrupted Value (0.0 - 1.0)")
ax.set_ylim(-0.1, 1.1)
# ax.text(2.0, 1.02, "CROSS-TALK DETECTED. INTERFERENCE.", color='tab:gray', fontsize=8, ha='center', alpha=0.6)
plt.tight_layout()
plt.savefig('card_d.png', dpi=300)


print("Successfully compiled and outputted all 5 graphics assets with correct Flutter IDs.")
# %%
