"""Date manipulation helper functions.

:copyright: 2006-2009 LOGILAB S.A. (Paris, FRANCE), all rights reserved.
:contact: http://www.logilab.fr/ -- mailto:contact@logilab.fr
:license: General Public License version 2 - http://www.gnu.org/licenses
"""
__docformat__ = "restructuredtext en"

import math

from datetime import date, datetime, timedelta
try:
    from mx.DateTime import RelativeDateTime, Date
except ImportError:
    from warnings import warn
    warn("mxDateTime not found, endsOfMonth won't be available")
    from datetime import date, timedelta
    def weekday(date):
        return date.weekday()
    endOfMonth = None
else:
    endOfMonth = RelativeDateTime(months=1, day=-1)

# NOTE: should we implement a compatibility layer between date representations
#       as we have in lgc.db ?

PYDATE_STEP = timedelta(days=1)

FRENCH_FIXED_HOLIDAYS = {
    'jour_an'        : '%s-01-01',
    'fete_travail'   : '%s-05-01',
    'armistice1945'  : '%s-05-08',
    'fete_nat'       : '%s-07-14',
    'assomption'     : '%s-08-15',
    'toussaint'      : '%s-11-01',
    'armistice1918'  : '%s-11-11',
    'noel'           : '%s-12-25',
    }

FRENCH_MOBILE_HOLIDAYS = {
    'paques2004'    : '2004-04-12',
    'ascension2004' : '2004-05-20',
    'pentecote2004' : '2004-05-31',

    'paques2005'    : '2005-03-28',
    'ascension2005' : '2005-05-05',
    'pentecote2005' : '2005-05-16',

    'paques2006'    : '2006-04-17',
    'ascension2006' : '2006-05-25',
    'pentecote2006' : '2006-06-05',

    'paques2007'    : '2007-04-09',
    'ascension2007' : '2007-05-17',
    'pentecote2007' : '2007-05-28',

    'paques2008'    : '2008-03-24',
    'ascension2008' : '2008-05-01',
    'pentecote2008' : '2008-05-12',

    'paques2009'    : '2009-04-13',
    'ascension2009' : '2009-05-21',
    'pentecote2009' : '2009-06-01',

    'paques2010'    : '2010-04-05',
    'ascension2010' : '2010-05-13',
    'pentecote2010' : '2010-05-24',

    'paques2011'    : '2011-04-25',
    'ascension2011' : '2011-06-02',
    'pentecote2011' : '2011-06-13',

    'paques2012'    : '2012-04-09',
    'ascension2012' : '2012-05-17',
    'pentecote2012' : '2012-05-28',
    }

# this implementation cries for multimethod dispatching

def get_step(dateobj):
    # assume date is either a python datetime or a mx.DateTime object
    if isinstance(dateobj, date):
        return PYDATE_STEP
    return 1 # mx.DateTime is ok with integers

def datefactory(year, month, day, sampledate):
    # assume date is either a python datetime or a mx.DateTime object
    if isinstance(sampledate, datetime):
        return datetime(year, month, day)
    if isinstance(sampledate, date):
        return date(year, month, day)
    return Date(year, month, day)

def weekday(dateobj):
    # assume date is either a python datetime or a mx.DateTime object
    if isinstance(dateobj, date):
        return dateobj.weekday()
    return dateobj.day_of_week

def str2date(datestr, sampledate):
    # NOTE: datetime.strptime is not an option until we drop py2.4 compat
    year, month, day = [int(chunk) for chunk in datestr.split('-')]
    return datefactory(year, month, day, sampledate)

def days_between(start, end):
    if isinstance(start, date):
        delta = end - start
        # datetime.timedelta.days is always an integer (floored)
        if delta.seconds:
            return delta.days + 1
        return delta.days
    else:
        return int(math.ceil((end - start).days))

def get_national_holidays(begin, end):
    """return french national days off between begin and end"""
    begin = datefactory(begin.year, begin.month, begin.day, begin)
    end = datefactory(end.year, end.month, end.day, end)
    holidays = [str2date(datestr, begin)
                for datestr in FRENCH_MOBILE_HOLIDAYS.values()]
    for year in xrange(begin.year, end.year+1):
        for datestr in FRENCH_FIXED_HOLIDAYS.values():
            date = str2date(datestr % year, begin)
            if date not in holidays:
                holidays.append(date)
    return [day for day in holidays if begin <= day < end]

def add_days_worked(start, days):
    """adds date but try to only take days worked into account"""
    step = get_step(start)
    weeks, plus = divmod(days, 5)
    end = start + ((weeks * 7) + plus) * step
    if weekday(end) >= 5: # saturday or sunday
        end += (2 * step)
    end += len([x for x in get_national_holidays(start, end + step)
                if weekday(x) < 5]) * step
    if weekday(end) >= 5: # saturday or sunday
        end += (2 * step)
    return end

def nb_open_days(start, end):
    assert start <= end
    step = get_step(start)
    days = days_between(start, end)
    weeks, plus = divmod(days, 7)
    if weekday(start) > weekday(end):
        plus -= 2
    elif weekday(end) == 6:
        plus -= 1
    open_days = weeks * 5 + plus
    nb_week_holidays = len([x for x in get_national_holidays(start, end+step)
                            if weekday(x) < 5 and x < end])
    return open_days - nb_week_holidays

def date_range(begin, end, step=None):
    """
    enumerate dates between begin and end dates.

    step can either be oneDay, oneHour, oneMinute, oneSecond, oneWeek
    use endOfMonth to enumerate months
    """
    if step is None:
        step = get_step(begin)
    date = begin
    while date < end :
        yield date
        date += step
