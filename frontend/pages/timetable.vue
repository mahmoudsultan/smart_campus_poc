<template>
  <v-container grid-list-md text-xs-center>
    <v-layout row wrap>
      <v-flex xs12>
        <v-breadcrumbs :items="items">
          <template v-slot:divider>
            <v-icon>chevron_right</v-icon>
          </template>
          <v-breadcrumbs-item
            slot="item"
            slot-scope="{ item }"
            :to="item.to"
            exact
          >
            <v-menu open-on-hover top offset-y>
              <template v-slot:activator="{ on }">
                <v-btn
                  v-on="on"
                  color="primary"
                  dark
                >
                  {{ item.text }}
                </v-btn>
                </a>
              </template>
              <v-list>
                <v-list-tile
                  v-for="(menu_item, index) in menu_items[item.category]"
                  :key="index"
                  @click="menuItemReact(item, menu_item)"
                >
                  <v-list-tile-title>{{ menu_item }}</v-list-tile-title>
                </v-list-tile>
              </v-list>
            </v-menu>
          </v-breadcrumbs-item>
        </v-breadcrumbs>
      </v-flex>

      <v-flex>
        <v-sheet height="400">
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
                <nuxt-link
                  :key="lec.code"
                  :to="{name: 'lecture_details-lec_id', params:{lec_id:lec.lec_id}}"
                  :style="{ top: timeToY(slotsMap[lec.start_timeslot]) + cellSpacing + 'px',
                            height: minutesToPixels(slotsRangeToMinuites(lec.start_timeslot,lec.end_timeslot)) - cellSpacing + 'px' }"
                  @click="open(lec)"
                  v-html="lectureToHtml(lec)"
                  class="my-event with-time"
                />
                </nuxt-link>
              </template>
            </template>
          </v-calendar>
        </v-sheet>
      </v-flex>
    </v-layout>
  </v-container>
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
    prof_id: 83,

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
  // fetch({ app: { $cookies, $axios }, store }) {
  //   const session = $cookies.get('session')
  //   // eslint-disable-next-line no-console
  //   console.log(session)
  //   // eslint-disable-next-line no-console
  //   console.log('hiiiiiiiiiiii', process.server, process.client)
  //   if (session) {
  //     const authHeaders = session.tokens
  //     store.commit('user', session.user)
  //     store.commit('auth', authHeaders)

  //     // eslint-disable-next-line no-console
  //     console.log(store.state)
  //   }
  // },
  mounted() {
    // eslint-disable-next-line no-console
    console.log(this.$store)
    this.$axios
      .$get('/courses/years')
      .then(ys => ys.forEach(y => this.menu_items.years.push(y)))
    this.$axios
      .$get('/courses/terms')
      .then(ts => ts.forEach(t => this.menu_items.terms.push(t)))

    this.$axios
      .$get(
        `/lectures/${this.current_term}/${this.current_year}`
      )
      .then(tt => this.fillTimeTableMap(tt))

    this.$refs.calendar.scrollToTime(this.firstSlotHour + ':00')
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
        .$get(`/lectures/${this.prof_id}/${term}/${year}`)
        .then(tt => this.fillTimeTableMap(tt))
    },
    fillTimeTableMap(tt) {
      this.timeTableMap = {}
      // eslint-disable-next-line no-console
      console.log(tt)
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
              <div>${lecture.title}</div>

              <div>${this.slotsMap[lecture.start_timeslot]} to ${
  this.slotsMap[lecture.end_timeslot]
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
