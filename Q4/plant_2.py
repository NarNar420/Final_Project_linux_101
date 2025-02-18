#!/usr/bin/env python3
import argparse
import matplotlib.pyplot as plt

def main():
    # 1) הגדרת פרמטרים בשורת הפקודה
    parser = argparse.ArgumentParser(description="Plot plant growth data from CLI arguments")
    parser.add_argument("--plant", type=str, required=True, help="Plant name")
    parser.add_argument("--height", nargs="+", type=float, required=True, help="Height data (cm) over time")
    parser.add_argument("--leaf_count", nargs="+", type=int, required=True, help="Leaf count data over time")
    parser.add_argument("--dry_weight", nargs="+", type=float, required=True, help="Dry weight data (g) over time")
    
    args = parser.parse_args()

    # 2) קריאת הערכים שהוזנו
    plant = args.plant
    height_data = args.height
    leaf_count_data = args.leaf_count
    dry_weight_data = args.dry_weight

    # 3) הדפסת הנתונים למסך (אופציונלי לצורך בדיקה)
    print(f"Plant: {plant}")
    print(f"Height data (cm): {height_data}")
    print(f"Leaf count data: {leaf_count_data}")
    print(f"Dry weight data (g): {dry_weight_data}")

    # 4) תרשים פיזור - Height vs Leaf Count
    plt.figure(figsize=(10, 6))
    plt.scatter(height_data, leaf_count_data, color='b')
    plt.title(f'Height vs Leaf Count for {plant}')
    plt.xlabel('Height (cm)')
    plt.ylabel('Leaf Count')
    plt.grid(True)
    plt.savefig(f"{plant}_scatter.png")
    plt.close()

    # 5) היסטוגרמה - התפלגות המשקל היבש
    plt.figure(figsize=(10, 6))
    plt.hist(dry_weight_data, bins=5, color='g', edgecolor='black')
    plt.title(f'Histogram of Dry Weight for {plant}')
    plt.xlabel('Dry Weight (g)')
    plt.ylabel('Frequency')
    plt.grid(True)
    plt.savefig(f"{plant}_histogram.png")
    plt.close()

    # 6) גרף קווי - גובה הצמח לאורך זמן
    # נקבע ציר X כמדדים (index) או כ-"Week 1", "Week 2" וכו'
    weeks = [f"Week {i+1}" for i in range(len(height_data))]
    plt.figure(figsize=(10, 6))
    plt.plot(weeks, height_data, marker='o', color='r')
    plt.title(f'{plant} Height Over Time')
    plt.xlabel('Time')
    plt.ylabel('Height (cm)')
    plt.grid(True)
    plt.savefig(f"{plant}_line_plot.png")
    plt.close()

    # 7) פלט סופי למסך
    print(f"Generated plots for {plant}:")
    print(f"  1) Scatter plot saved as {plant}_scatter.png")
    print(f"  2) Histogram saved as {plant}_histogram.png")
    print(f"  3) Line plot saved as {plant}_line_plot.png")

if __name__ == "__main__":
    main()
