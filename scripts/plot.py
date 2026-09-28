import json
import matplotlib.pyplot as plt
import numpy


def plot_velocity_from_log(file_path: str):
    velocities = []
    forces = []
    distances = []
    direction_x = []
    direction_y = []

    try:
        with open(file_path, "r", encoding="utf-8") as file:
            for line_number, line in enumerate(file, start=1):
                line = line.strip()
                if not line:
                    continue  # Пропускаем пустые строки

                try:
                    data = json.loads(line)
                    velocities.append(data["velocity"])
                    forces.append(data["force"])
                    distances.append(data["distance_to_target"])
                    direction_x.append(data["direction"]["x"])
                    direction_y.append(data["direction"]["y"])
                except (json.JSONDecodeError, KeyError) as e:
                    print(
                        f"Предупреждение: Пропущена некорректная строка {line_number}: {e}"
                    )
    except FileNotFoundError:
        print(
            f"Ошибка: Файл '{file_path}' не найден. Убедитесь, что указали правильный путь."
        )
        return

    if not velocities:
        print("Данные для построения графика отсутствуют.")
        return

    point_numbers = list(range(1, len(velocities) + 1))

    fig, (ax1, ax2, ax3, ax4) = plt.subplots(
        nrows=4, ncols=1, figsize=(10, 8), sharex=True
    )

    ax1.plot(
        point_numbers,
        velocities,
        marker=".",
        linestyle="-",
        color="b",
        label="Velocity",
    )
    ax1.set_ylabel("Velocity (Скорость)")
    ax1.set_title("Анализ движения персонажа Godot")
    ax1.grid(True, linestyle="--", alpha=0.5)

    ax2.plot(
        point_numbers,
        forces,
        marker=".",
        linestyle="-",
        color="b",
        label="Velocity",
    )
    ax2.set_ylabel("Force")

    ax3.plot(
        point_numbers,
        distances,
        marker=".",
        linestyle="-",
        color="b",
        label="Distance",
    )
    ax3.set_ylabel("Distance")

    frames = numpy.arange(1, len(direction_x) + 1)
    base_y = numpy.zeros(len(direction_x))
    ax4.axhline(0, color="gray", linestyle="--", alpha=0.5)
    ax4.quiver(frames, base_y, direction_x, direction_y, width=0.001, scale=10)

    plt.tight_layout()
    plt.show()


plot_velocity_from_log(
    "/home/user/.local/share/godot/app_userdata/AI_game_lab/game_logs.txt"
)
