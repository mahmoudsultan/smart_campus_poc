<template>
    <v-sheet height="400">
        <v-calendar

        ref="calendar"
        :now="hackyWeekStartDay"
        :value="hackyWeekStartDay"
        :day-format="(t,s)=>''"
        :interval-minutes="cellSize"
        :first-interval="firstSlot"
        :short-weekdays="false"
        :weekdays="weekDays"
        color="primary"
        type="week"
        >
        <template #dayBody="{ date, timeToY, minutesToPixels }">
            <template v-for="lec in timeTableMap[date]">
            <nuxt-link
                :key="lec.code"
                :to="{name: 'lecture_details-lec_id', params:{lec_id:lec.lec_id}}"
                :style="{ top: timeToY(slotsMap[lec.start_timeslot]) + cellSpacing + 'px',
                        height: minutesToPixels(slotsRangeToMinuites(lec.start_timeslot,lec.end_timeslot)) - cellSpacing + 'px' }"
                @click="open(lec)"
                class="my-event with-time"
            >
            <v-container grid-list-xs>
                <v-layout column>
                <v-flex xs12>
                    <span class="font-weight-medium subheading">{{ lec.title }}</span>
                </v-flex>
                <v-flex class="lecture-time" xs12>
                    <p>{{ slotsMap[lec.start_timeslot] }}</p>
                    <p> to </p>
                    <p>{{ slotsMap[lec.end_timeslot] }}</p>
                </v-flex>
                </v-layout>
            </v-container>
            </nuxt-link>
            </template>
        </template>
        </v-calendar>
    </v-sheet>
</template>

<script>
export default {
  data: () => ({
    timeTableMap: {},
    cellSize: 30,
    slotSize: 50,
    numberOfSlots: 12,
    weekDays: [6, 0, 1, 2, 3, 4],
    hackyWeekStartDay: '2019-01-05', // Set up any saturday as a hack
    firstSlotHour: 8,
    firstSlotMinutes: 30,
    cellSpacing: 10,
    current_term: 'fall',
    current_year: 2018,
    uid: 2,

    menu_items: {
      years: [],
      terms: []
    },
    items: [
      {
        category: 'years',
        text: '2018',
        disabled: false,
        href: 'timetable'
      },
      {
        category: 'terms',
        text: 'Fall',
        disabled: true,
        href: 'timetable'
      }
    ]
  }),
  computed: {
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
  async mounted() {
    const ys = await this.$axios.$get('/courses/years')
    this.items[0].text = Math.max(...ys.map(y => parseInt(y)))

    ys.forEach(y => this.menu_items.years.push(y))
    const ts = await this.$axios.$get('/courses/terms')
    this.items[1].text = ts[ts.length - 1]
    ts.forEach(t => this.menu_items.terms.push(t))
    const tt = await this.$axios.$get(
      `/lectures/${this.current_term}/${this.current_year}`)

    this.fillTimeTableMap(tt)

    // this.$refs.calendar.scrollToTime(this.firstSlotHour + ':00')
  },
  methods: {
    menuItemReact(item, menuItem) {
      let term = this.current_term
      let year = this.current_year
      if (item.category === 'terms') {
        term = menuItem
        this.current_term = term
        item.text = term
      } else if (item.category === 'years') {
        year = menuItem
        this.current_year = year
        item.text = year
      }
      this.$axios
        .$get(`/lectures/${term}/${year}`)
        .then(tt => this.fillTimeTableMap(tt))
    },
    fillTimeTableMap(tt) {
      this.timeTableMap = {}

      const pad = n => this.padNumber(n, 2)
      tt.forEach((e) => {
        const date = this.dayNumberToDate(e.day)
        const dateString = `${date.getFullYear()}-${pad(
          date.getMonth() + 1
        )}-${pad(date.getDate())}`
        if (dateString in this.timeTableMap) {
          this.timeTableMap[dateString].push(e)
        } else {
          this.$set(this.timeTableMap, dateString, [e])
        }
        // Add the lecture to localstorage
        localStorage.setItem(e.lec_id, JSON.stringify(e))
      })
    },
    padNumber(num, len) {
      return ('' + num).padStart(2, '0')
    },
    open(event) {
      alert(event.title)
    },
    dayNumberToDate(dayNumber) {
      const dt = new Date(this.hackyWeekStartDay)
      dt.setDate(dt.getDate() + dayNumber)
      return dt
    },
    slotsRangeToMinuites(start, end) {
      return (end - start + 1) * this.slotSize
    },
    lectureToHtml(lecture) {
      return `<div class=lecture-text>
              <div>Definse Aganist the Dark Magic</div>

              <div>${this.slotsMap[lecture.start_timeslot]} to ${
  this.slotsMap[lecture.end_timeslot]
}</div>
      </div>`
    }
  }
}
</script>
<style lang="stylus" scoped>
  .menu-btn {
     text-decoration: underline;
  }
  .lecture-text > div {
    padding: 0px;
  }
  .my-event {
    background-color: #16d6cf;
    background-image: linear-gradient(147deg, #16d6cf 0%, #435bb9 74%);
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
    border-radius: 1rem;

    &.with-time {
      white-space: normal;
      text-decoration: none;
      position: absolute;
      right: 4px;
      margin-right: 0px;
      border: 2px solid #fff;
    }
  }
  .lecture-time p {
    margin: 0;
    font-weight: bold;
  }
</style>
