<template>
  <v-layout>
    <v-flex>
      <v-sheet height="400">
        <!-- now is normally calculated by itself, but to keep the calendar in this date range to view events -->
        <v-calendar

          ref="calendar"
          :now="hackyWeekStartDay"
          :value="hackyWeekStartDay"
          :day-format="()=>''" 
          :interval-minutes="slotSize"
          :first-interval="startSlot"
          :dark="true"
          :short-weekdays="false"
          :weekdays="weekDays"
          :interval-format="()=>''"
          color="primary"
          type="week"
        >
          <template #dayBody="{ date, timeToY, minutesToPixels }">
            <template v-for="event in timeTableMap[date]">
              <div
                :key="event.code"
                :style="{ top: timeToY(event.startSlot*slotSize) + 'px',
                          height: minutesToPixels( slotSize*(event.endSlot-event.startSlot) ) + 'px' }"
                @click="open(event)"
                class="my-event with-time"
                v-html="event.code"
              />
            </template>
          </template>
        </v-calendar>
      </v-sheet>
    </v-flex>
  </v-layout>
</template>
<script>
export default {
  data: () => ({
    slotSize: 50,
    numberOfSlots: 12,
    weekDays: [6, 0, 1, 2, 3, 4],
    hackyWeekStartDay: '2019-01-05', // Set up any saturday as a hack
    firstSlotHour: 8,
    firstSlotMinutes: 30,
    timeTable: [
      {
        code: 'cc123',
        day: 0,
        startSlot: 0,
        endSlot: 1
      },
      {
        code: 'cc124',
        day: 0,
        startSlot: 3,
        endSlot: 4
      },
      {
        code: 'cc125',
        day: 1,
        startSlot: 2,
        endSlot: 5
      }
    ],
    events: [
      {
        title: 'Weekly Meeting',
        date: '2019-01-07',
        time: '09:00',
        duration: 45
      },
      {
        title: "Thomas' Birthday",
        date: '2019-01-10'
      },
      {
        title: 'Mash Potatoes',
        date: '2019-01-09',
        time: '12:30',
        duration: 180
      }
    ]
  }),
  computed: {
    // convert the list of events into a map of lists keyed by date
    eventsMap() {
      const map = {}
      this.events.forEach(e => (map[e.date] = map[e.date] || []).push(e))
      return map
    },
    timeTableMap() {
      const map = {}
      this.timeTable.forEach(e =>
        (map[this.dayIndexToDate(e.date)] =
          map[this.dayIndexToDate(e.date)] || []).push(e)
      )
      return map
    },
    slotsMap() {
      const map = {}
      const dt = new Date(2019, 1, 1, this.firstSlotHour, this.firstSlotMinutes)
      for (let i = 0; i < this.numberOfSlots; i++) {
        map[i] = `${dt.getHours}:${dt.getMinutes}`
        dt.setMinutes(dt.getMinutes + this.slotSize)
      }
      return map
    },
    startSlot() {
      const start = this.firstSlotHour / (this.slotSize / 60)
      const residue = this.firstSlotMinutes / this.slotSize
      return start + residue
    }
  },
  mounted() {
    this.$refs.calendar.scrollToTime(this.firstSlotHour + ':00')
  },
  methods: {
    open(event) {
      alert(event.title)
    },
    dayIndexToDate(index) {
      const dt = new Date(this.hackyWeekStartDay)
      dt.setDate(dt.getDate() + index)
      return dt
    }
  }
}
</script>
<style lang="stylus" scoped>
  .my-event {
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
    border-radius: 2px;
    background-color: #1867c0;
    color: #ffffff;
    border: 1px solid #1867c0;
    font-size: 12px;
    padding: 3px;
    cursor: pointer;
    margin-bottom: 1px;
    left: 4px;
    margin-right: 8px;
    position: relative;

    &.with-time {
      position: absolute;
      right: 4px;
      margin-right: 0px;
    }
  }
</style>
