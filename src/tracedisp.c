/* pMARS -- a portable Memory Array Redcode Simulator
 *
 * tracedisp.c: file-based battle-trace "display" backend for CodeClash replays.
 *
 * This is a no-graphics display: instead of rendering the core to a screen, it writes a
 * compact event stream of the battle to the file named by the -T option, for later
 * distillation into a replay (see codeclash/arenas/corewar/trace.py).
 *
 * IMPORTANT (fairness): the stream records only cell OWNERSHIP / activity (which warrior
 * executed or wrote which address) and process spawn/death -- never the instruction stored
 * in a cell. A competitor can therefore watch an opponent's behaviour but cannot reconstruct
 * its source, matching the -b (brief) rule that suppresses source listings elsewhere.
 *
 * Like curdisp.c / uidisp.c this file is #included into sim.c, so it sees the simulator
 * globals (coreSize, warriors, cycles, warrior[], W). Emission is runtime-gated on traceFp,
 * which is opened only when -T is given: with -T absent every display_* macro is a single
 * predicted-not-taken branch, so scored (non-traced) runs are unaffected.
 *
 * Stream grammar (whitespace-separated, one record per line):
 *   V 1 <coreSize> <warriors> <cycles>        version + battle params (once, at start)
 *   W <idx> <position> <length> <name>        one per warrior, at each round start
 *   R <round>                                 round marker (cycle counter resets)
 *   e <cycle> <warrior> <addr>                warrior executed the instruction at addr
 *   w <cycle> <warrior> <addr>                warrior wrote to addr
 *   s <cycle> <warrior> <tasks>               warrior's process count is now <tasks>
 *   x <cycle> <warrior> <tasks> <addr>        a process died (DAT) at addr; <tasks> remain
 *   D <cycle> <warrior>                        warrior eliminated (last process died)
 * Reads and in-place dec/inc are intentionally omitted from v1 to keep the stream lean;
 * they can be enabled later if scanner/decrement visualisation is wanted.
 */

static FILE *traceFp = NULL;
static long  traceCycle = 0;
static int   traceRound = 0;

static void
trace_init(void)
{
  if (traceFileName == NULL)
    return;
  traceFp = fopen(traceFileName, "w");
  if (traceFp == NULL)
    return;
  fprintf(traceFp, "V 1 %ld %d %ld\n", (long) coreSize, warriors, (long) cycles);
}

/* Called once per round (display_clear), after warriors are positioned and copied to core.
 * Emits each warrior's load position/length and resets the per-round cycle counter. */
static void
trace_clear(void)
{
  int     i;
  if (traceFp == NULL)
    return;
  traceCycle = 0;
  for (i = 0; i < warriors; i++)
    fprintf(traceFp, "W %d %ld %d %s\n", i, (long) warrior[i].position,
            warrior[i].instLen, warrior[i].name ? warrior[i].name : "?");
  fprintf(traceFp, "R %d\n", ++traceRound);
}

static void
trace_close(void)
{
  if (traceFp == NULL)
    return;
  fclose(traceFp);
  traceFp = NULL;
}

#define display_init()      trace_init()
#define display_clear()     trace_clear()
#define display_close()     trace_close()
#define display_cycle()     do { if (traceFp) traceCycle++; } while (0)

#define display_exec(addr) \
  do { if (traceFp) fprintf(traceFp, "e %ld %d %ld\n", traceCycle, (int) (W - warrior), (long) (addr)); } while (0)
#define display_write(addr) \
  do { if (traceFp) fprintf(traceFp, "w %ld %d %ld\n", traceCycle, (int) (W - warrior), (long) (addr)); } while (0)

/* Omitted from the v1 stream (kept as no-ops so the sim's call sites still compile). */
#define display_read(addr)
#define display_dec(addr)
#define display_inc(addr)
#define display_push(val)

/* warNum/warrior here is the warrior index passed by the caller (it shadows warrior[]). */
#define display_spl(warNum, tasks) \
  do { if (traceFp) fprintf(traceFp, "s %ld %d %d\n", traceCycle, (int) (warNum), (int) (tasks)); } while (0)
#define display_dat(addr, warNum, tasks) \
  do { if (traceFp) fprintf(traceFp, "x %ld %d %d %ld\n", traceCycle, (int) (warNum), (int) (tasks), (long) (addr)); } while (0)
#define display_die(warNum) \
  do { if (traceFp) fprintf(traceFp, "D %ld %d\n", traceCycle, (int) (warNum)); } while (0)
