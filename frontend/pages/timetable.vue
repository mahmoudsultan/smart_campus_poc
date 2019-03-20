<template>
  <v-layout>
    <v-flex>
      <v-sheet height="400">
        <!-- :interval-format="(t,s)=>t.hour<19?`${padNumber(t.hour,2)} : ${padNumber(t.minute,2)}`:''" -->
        <!-- now is normally calculated by itself, but to keep the calendar in this date range to view events -->

        <v-calendar

          ref="calendar"
          :now="hackyWeekStartDay"
          :value="hackyWeekStartDay"
          :day-format="(t,s)=>''" 
          :interval-minutes="cellSize"
          :first-interval="firstSlot"
          :dark="true"
          :short-weekdays="false"
          :weekdays="weekDays"
          color="primary"
          type="week"
        >
          <template #dayBody="{ date, timeToY, minutesToPixels }">
            <template v-for="lec in timeTableMap[date]">
              <div
                :key="lec.code"
                :style="{ top: timeToY(slotsMap[lec.startSlot]) + cellSpacing + 'px',
                          height: minutesToPixels(slotsRangeToMinuites(lec.startSlot,lec.endSlot)) - cellSpacing + 'px' }"
                class="my-event with-time"
                @click="open(lec)"
                v-html="lectureToHtml(lec)"
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
    timeTable: [
      {
        code: 'cc123',
        day: 'sat',
        startSlot: 0,
        endSlot: 2
      },
      {
        code: 'cc124',
        day: 'sun',
        startSlot: 3,
        endSlot: 4
      },
      {
        code: 'cc125',
        day: 'mon',
        startSlot: 2,
        endSlot: 5
      },
      {
        code: 'cc126',
        day: 'tue',
        startSlot: 3,
        endSlot: 5
      },
      {
        code: 'cc127',
        day: 'wed',
        startSlot: 7,
        endSlot: 9
      },
      {
        code: 'cc128',
        day: 'thurs',
        startSlot: 7,
        endSlot: 9
      }
    ],
    timeTableMap: {},
    cellSize: 30,
    slotSize: 50,
    numberOfSlots: 12,
    weekDays: [6, 0, 1, 2, 3, 4],
    hackyWeekStartDay: '2019-01-05', // Set up any saturday as a hack
    firstSlotHour: 8,
    firstSlotMinutes: 30,
    cellSpacing: 10
  }),
  computed: {
    // convert the list of events into a map of lists keyed by date
    eventsMap() {
      const map = {}
      this.events.forEach(e => (map[e.date] = map[e.date] || []).push(e))
      return map
    },
    slotsMap() {
      const map = {}
      const dt = new Date(2019, 1, 1, this.firstSlotHour, this.firstSlotMinutes)
      for (let i = 0; i < this.numberOfSlots; i++) {
        map[i] = `${this.padNumber(dt.getHours(), 2)}:${this.padNumber(
          dt.getMinutes(),
          2
        )}`
        dt.setMinutes(dt.getMinutes() + this.slotSize)
      }
      return map
    },
    firstSlot() {
      const start = this.firstSlotHour / (this.cellSize / 60)
      const residue = this.firstSlotMinutes / this.cellSize
      return start + residue
    }
  },
  mounted() {
    // eslint-disable-next-line no-console
    console.log(this.$route)
    this.$axios
      .$get('http://localhost:5000/12/courses/12/12')
      .then(tt => this.fillTimeTableMap(tt))

    this.$refs.calendar.scrollToTime(this.firstSlotHour + ':00')
  },
  methods: {
    fillTimeTableMap(tt) {
      // eslint-disable-next-line no-console
      console.log(tt)
      const pad = n => this.padNumber(n, 2)
      tt.forEach(e => {
        const date = this.dayNameToDate(e.day)
        const dateString = `${date.getFullYear()}-${pad(
          date.getMonth() + 1
        )}-${pad(date.getDate())}`

        if (dateString in this.timeTableMap) {
          this.timeTableMap[dateString].push(e)
        } else {
          this.$set(this.timeTableMap, dateString, [e])
        }
      })
    },
    padNumber(num, len) {
      return ('' + num).padStart(2, '0')
    },
    open(event) {
      alert(event.title)
    },
    dayNameToDate(dayName) {
      const dt = new Date(this.hackyWeekStartDay)
      const dayMap = { sat: 0, sun: 1, mon: 2, tue: 3, wed: 4, thurs: 5 }
      dt.setDate(dt.getDate() + dayMap[dayName])
      return dt
    },
    slotsRangeToMinuites(start, end) {
      return (end - start + 1) * this.slotSize
    },
    lectureToHtml(lecture) {
      return `<div class=lecture-text>
              <div>${lecture.code}</div>

              <div>${this.slotsMap[lecture.startSlot]} to ${
        this.slotsMap[lecture.endSlot]
      }</div>
      </div>`
    }
  }
}
</script>
<style lang="stylus" scoped>
  .lecture-text > div {
    padding: 10px;
  }
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
    margin-bottom: 3px;
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
